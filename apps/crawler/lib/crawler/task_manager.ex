defmodule Crawler.TaskManager do

  use GenServer
  require Logger

  ## api

  def start_link(max, opts \\ []) do
    GenServer.start_link(__MODULE__, max, opts)
  end

  def search(query, manager, provider, timeout \\ 5000) do
    GenServer.call(manager, {:search, {provider, query}})
    receive do
      {:result, result} -> result
    after
      timeout ->
        #TODO kill the task not needed anymore
        :timeout
    end
  end


  ## callbacks and internal stuff

  defmodule State do
    @moduledoc false
    defstruct [:max, :queue, :supervisor]
  end


  def init(max) do
    {:ok, supervisor} = DynamicSupervisor.start_link(strategy: :one_for_one)
    start = %State{ max: max, queue: :queue.new, supervisor: supervisor }
    Logger.debug "starting start created:\n\t#{inspect start}"
    {:ok, start}
  end

  # get the call to add on task
  def handle_call({:search, args}, {pid, _ref}, state) do
    # startup a new task if the max is not reached
    c = Task.Supervisor.children(state.supervisor)
    if length(c) < state.max do
      start_task(state.supervisor, pid, args)
      {:noreply, state}
    else # otherwise queue it
      q = :queue.in({pid, args}, state.queue)
      {:noreply, %State{ state | queue: q}}
    end
  end

  # a task returned without error
  def handle_info({_, :ok}, state) do
    {:noreply, state}
  end

  # a task shutdown (for whatever reason)
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
  def handle_info(msg, state) do
    Logger.warn "unexpected handle_info call, msg: #{inspect msg}"
    {:noreply, state}
  end

  defp start_task(supervisor, client, {provider, query}) do
    %Task{} = Task.Supervisor.async(supervisor, fn ->
      send client, {:ok, provider.search(query)}
      :ok
    end)
  end

end
