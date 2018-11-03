defmodule Crawler.TaskManager do

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
  execute ``provider.search(query)`` in an rate limited way.
  """
  @spec search(String.t(), GenServer.name(), module(), timeout()) :: search_result()
  def search(query, manager, provider, timeout \\ 50000) do
    GenServer.call(manager, {:search, {provider, query}}, timeout)
  end


  ## callbacks and internal stuff

  defmodule State do
    @moduledoc false
    defstruct [:max, :queue, :supervisor]
  end


  @doc false
  def init(max) do
    {:ok, supervisor} = Task.Supervisor.start_link(
      strategy: :one_for_one,
      restart: :transient,
      max_children: max
    )
    start = %State{ max: max, queue: :queue.new, supervisor: supervisor }
    Logger.debug "#{__MODULE__} started in #{inspect self()} inits with #{inspect start}"
    {:ok, start}
  end

  # get the call to add on task
  @doc false
  def handle_call({:search, args}, client, state) do
    # startup a new task if the max is not reached
    c = Task.Supervisor.children(state.supervisor)
    Logger.debug "current supervised children #{inspect length(c)}"
    if length(c) < state.max do
      Logger.debug "directly start task #{inspect args}"
      start_task(state.supervisor, client, args)
      {:noreply, state}
    else # otherwise queue it
      Logger.debug "request #{inspect args} will be queued"
      q = :queue.in({client, args}, state.queue)
      {:noreply, %State{ state | queue: q}}
    end
  end

  # a task returned without error
  @doc false
  def handle_info({_ref, :ok}, state) do
    Logger.debug "a Task ended successful"
    {:noreply, state}
  end

  # a task shutdown (for whatever reason)
  @doc false
  def handle_info({:DOWN, _ref, :process, _pid, _reason}, state) do
    # add new task if aviable
    queue = state.queue
    case :queue.out(queue) do
      {:empty, ^queue} -> {:noreply, state}
      {{:value, {pid, args}}, q} ->
        start_task(state.supervisor, pid, args)
        {:noreply, %State{state | queue: q}}
    end
  end

  # only to log unexpected messages
  @doc false
  def handle_info(msg, state) do
    Logger.warn "unexpected handle_info call, msg: #{inspect msg}"
    {:noreply, state}
  end

  defp start_task(supervisor, client, args = {provider, query}) do
    Task.Supervisor.async_nolink(supervisor, fn ->
      Logger.debug "Task client [#{inspect client}], args [#{inspect args}]"
      result = provider.search(query)
      Logger.debug "Task resulted in #{inspect result}"
      GenServer.reply(client, result)
      :ok
    end)
  end

end
