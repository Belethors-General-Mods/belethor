defmodule Crawler.TaskManager do
  @moduledoc """
  Module to limit the amount of concurrent running task.
  If the task maximum is reached, the request will be queued.
  """

  defstruct [:max, :queue, :supervisor]

  use GenServer
  require Logger

  @type search_result() :: list(any())

  ## api

  @doc "start an instance, with options"
  @spec start_link(pos_integer(), GenServer.options()) :: Supervisor.on_start()
  def start_link(max, opts \\ []) do
    GenServer.start_link(__MODULE__, max, opts)
  end

  @doc """
  execute `provider.search(query)` in an rate limited way.
  """
  @spec search(String.t(), GenServer.name(), module(), timeout()) :: search_result()
  def search(query, manager, provider, timeout \\ 5_000) do
    GenServer.call(manager, {:search, {provider, query}}, timeout)
  end

  # callbacks and internal stuff
  @doc false
  def init(max) do
    {:ok, supervisor} =
      Task.Supervisor.start_link(
        strategy: :one_for_one,
        restart: :transient,
        max_children: max,
        max_restarts: 0
      )

    start = %Crawler.TaskManager{
      max: max,
      queue: :queue.new(),
      supervisor: supervisor
    }

    Logger.debug(fn ->
      "#{__MODULE__} started in #{inspect(self())} inits with #{inspect(start)}"
    end)

    {:ok, start}
  end

  # get the call to add on task
  @doc false
  def handle_call({:search, args}, client, state) do
    # startup a new task if the max is not reached
    # otherwise queue it
    if max_reached?(state) do
      Logger.debug(fn -> "directly start task #{inspect(args)}" end)
      start_task(state.supervisor, client, args)
      {:noreply, state}
    else
      Logger.debug(fn -> "request #{inspect(args)} will be queued" end)
      q = :queue.in({client, args}, state.queue)
      {:noreply, %Crawler.TaskManager{state | queue: q}}
    end
  end

  # a task returned without error
  @doc false
  def handle_info({ref, :ok}, state) when is_reference(ref) do
    Logger.debug(fn -> "a Task (#{inspect(ref)}) ended successful" end)
    {:noreply, state}
  end

  # a monitored process died (for whatever reason)
  @doc false
  def handle_info(down = {:DOWN, _ref, :process, _pid, _reason}, state) do
    Logger.debug(fn -> "got a down msg : #{inspect(down)}" end)
    # add new task if aviable
    queue = state.queue

    case :queue.out(queue) do
      {:empty, ^queue} ->
        {:noreply, state}

      {{:value, {pid, args}}, q} ->
        if max_reached?(state) do
          start_task(state.supervisor, pid, args)
          {:noreply, %Crawler.TaskManager{state | queue: q}}
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

  defp start_task(supervisor, client = {client_pid, _id}, {provider, query})
       when is_pid(client_pid) do
    Logger.debug(fn -> "current supervised children #{inspect(count_tasks(supervisor))}" end)

    %Task{} =
      Task.Supervisor.async_nolink(supervisor, fn ->
        Process.link(client_pid)
        result = provider.search(query)
        GenServer.reply(client, result)
        :ok
      end)
  end
end
