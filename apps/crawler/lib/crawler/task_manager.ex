defmodule Crawler.TaskManager do
  use GenServer
  require Logger

  ## api

  def start_link(max) do
    GenServer.start_link(__MODULE__, max, name: __MODULE__)
  end

  def search(query, provider, timeout \\ 5000) do
    GenServer.call(__MODULE__, {:search, {provider, args}})
    receive do
      {:result, result} -> result
    after
      timeout ->
        #TODO kill the task not needed anymore
        :timeout
    end
  end


  ## Callbacks

  def init(max) do
    Logger.info "starting up #{__MODULE__} with max #{max}"
    {:ok, {max, :queue.new}}
  end

  # get the call to add on task
  def handle_call({:search, args}, {pid, _ref}, state = {max, queue}) do
    # startup a new task if the max is not reached
    c = Task.Supervisor.children(Crawler.TaskSupervisor)
    if length(c) < max do
      start_task(pid, args)
      {:reply, :ok, state}
    else # otherwise queue it
      q = :queue.in({pid, args}, queue)
      {:reply, :ok, {max, q}}
    end
  end

  # a task returned without error
  def handle_info({_, :ok}, state) do
    {:noreply, state}
  end

  # a task shutdown (for whatever reason)
  def handle_info({:DOWN, _ref, :process, _pid, _reason}, state = {max, queue}) do
    # add new task if aviable
    case :queue.out(queue) do
      {:empty, ^queue} -> {:noreply, state}
      {{:value, {pid, args}}, q} ->
        start_task(pid, args)
        {:noreply, {max, q}}
    end
  end

  # only to log unexpected messages
  def handle_info(msg, state) do
    Logger.warn "unexpected handle_info call, msg: #{inspect msg}"
    {:noreply, state}
  end

  defp start_task(client, {provider, query}) do
    %Task{} = Task.Supervisor.async_nolink(Crawler.TaskSupervisor, fn ->
      send client, {:result, provider.search(query)}
      :ok
    end)
  end

end
