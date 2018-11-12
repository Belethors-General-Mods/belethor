defmodule TaskManagerTest do
  use ExUnit.Case
  require Logger
  alias Crawler.TaskManager

  defmodule EchoProvider do
    def search(query) do
      query
    end
  end

  defmodule BlockingProvider do
    def search(query) do
      :timer.sleep(:infinity)
      query
    end
  end

  test "basic test ensure provider.search(query) gets called" do
    input = ["basic testvalue"]
    {:ok, mng} = TaskManager.start_link(1)
    result = TaskManager.search(input, mng, EchoProvider)
    assert result == input
    Process.sleep(400)
  end

  test "don't hang on unending tasks" do
    {:ok, mng} = TaskManager.start_link(3)
    input = ["unending testvalue"]

    timeout = 1000

    block = fn ->
      {pid, ref} =
        Process.spawn(
          fn ->
            TaskManager.search(:lemming, mng, BlockingProvider, 500)
          end,
          [:monitor]
        )

      receive do
        {:DOWN, ^ref, :process, ^pid, {reason, _more_info}} -> reason
      end
    end

    valid = fn ->
      try do
        TaskManager.search(input, mng, EchoProvider, timeout)
      catch
        :exit, msg = {reason, _} ->
          Logger.warn("valid request failed with #{inspect(msg)}")
          reason
      end
    end

    queue = [block, block, block, valid]
    expected = [:timeout, :timeout, :timeout, input]

    actual =
      queue
      |> Enum.map(&Task.async/1)
      |> Enum.map(fn t -> Task.await(t, timeout) end)

    assert expected == actual

    Process.sleep(400)
  end

  test "allow multiple managers running at the same time" do
    input_a = ["AAAAAAAAAAAAAa"]
    input_b = ["BBBBBBBBBBbbb"]
    input_c = [12, 23, 34]

    {:ok, mng_a} = TaskManager.start_link(1)
    {:ok, mng_b} = TaskManager.start_link(1)
    {:ok, mng_c} = TaskManager.start_link(1)

    assert mng_a != mng_b != mng_c

    request = fn input, mng ->
      fn -> TaskManager.search(input, mng, EchoProvider) end
    end

    queue = [
      request.(input_a, mng_a),
      request.(input_b, mng_b),
      request.(input_c, mng_c)
    ]

    result =
      queue
      |> Enum.map(&Task.async/1)
      |> Enum.reverse()
      |> Enum.map(&Task.await/1)

    assert result == [input_c, input_b, input_a]

    Process.sleep(400)
  end
end
