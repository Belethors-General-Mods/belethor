defmodule Crawler.TaskManager do
  @moduledoc """
  Module to limit the amount of concurrent running task.
  If the task maximum is reached, the request will be queued.
  """

  # struct to represent the inner gen_server state
  defstruct [:max, :queue, :supervisor]

  use GenServer
  require Logger
  alias Crawler

  # macro to correct log debug messages
  defmacrop debug(msg) do
    quote do
      :ok = Logger.debug(fn -> unquote(msg) end)
    end
  end

  @type max() :: pos_integer() | :infinty

  @typedoc """
  start options for starting up a `TaskManager`
  """
  @type start_options() ::
          {:max, max()}
          | {:task_supervisor, Supervisor.supervisor()}
          | GenServer.options()

  ## api

  @doc """
  start an instance

  `:max` and `:task_supervisor` are required:
  - `:max` the maximum tasks running in parrallel
  - `:task_manager` the `Task.Supervisor` to supervise the tasks.

  `GenServer.options()` can be added, but are optional.
  """
  @spec start_link(opts :: [start_options()]) :: GenServer.on_start()
  def start_link(opts) do
    {max, opts1} = Access.pop(opts, :max)
    {supi, opts2} = Access.pop(opts1, :task_supervisor)
    GenServer.start_link(__MODULE__, {max, supi}, opts2)
  end

  @doc """
  execute `client.search(query)` in a rate limited way.

  the search callback is defined in `Crawler.Client`.
  """
  @spec search(
          query :: Crawler.Client.query(),
          manager :: GenServer.name(),
          client :: module(),
          timeout()
        ) :: Crawler.Client.search_result()
  def search(query, manager, client, timeout \\ 5_000) do
    GenServer.call(manager, {:search, {client, query}}, timeout)
  end

  # callbacks and internal stuff
  @doc false
  def init({max, supervisor}) do
    start = %__MODULE__{
      max: max,
      queue: :queue.new(),
      supervisor: supervisor
    }

    debug("#{__MODULE__} started in #{inspect(self())} inits with #{inspect(start)}")

    {:ok, start}
  end

  # get the call to add on task
  @doc false
  def handle_call({:search, args}, client, state) do
    # startup a new task if the max is not reached
    # otherwise queue it
    if max_reached?(state) do
      debug("directly start task #{inspect(args)}")
      :ok = start_task(state.supervisor, client, args)
      {:noreply, state}
    else
      debug("request #{inspect(args)} will be queued")
      q = :queue.in({client, args}, state.queue)
      {:noreply, %__MODULE__{state | queue: q}}
    end
  end

  # a task returned without error
  @doc false
  def handle_info({ref, :ok}, state) when is_reference(ref) do
    debug("a Task (#{inspect(ref)}) ended successful")
    {:noreply, state}
  end

  # a monitored process died (for whatever reason)
  @doc false
  def handle_info(down = {:DOWN, _ref, :process, _pid, _reason}, state) do
    debug("got a down msg : #{inspect(down)}")
    # add new task if aviable
    queue = state.queue

    case :queue.out(queue) do
      {:empty, ^queue} ->
        {:noreply, state}

      {{:value, {pid, args}}, q} ->
        if max_reached?(state) do
          :ok = start_task(state.supervisor, pid, args)
          {:noreply, %__MODULE__{state | queue: q}}
        else
          {:noreply, state}
        end
    end
  end

  defp max_reached?(state) do
    state.max > count_tasks(state.supervisor)
  end

  defp count_tasks(supervisor) do
    supervisor |> Task.Supervisor.children() |> length
  end

  defp start_task(
         supervisor,
         client = {client_pid, _id},
         {provider_client, query}
       )
       when is_pid(client_pid) do
    debug("current supervised children #{inspect(count_tasks(supervisor))}")

    %Task{} =
      Task.Supervisor.async_nolink(supervisor, fn ->
        Process.link(client_pid)
        result = provider_client.search(query)
        GenServer.reply(client, result)
        :ok
      end)

    :ok
  end
end
