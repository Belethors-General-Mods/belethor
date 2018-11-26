defmodule TaskManagerTest do
  use ExUnit.Case
  require Logger
  alias Crawler.TaskManager

  defp start(max) do
    {:ok, supervisor} =
      Task.Supervisor.start_link(
        strategy: :one_for_one,
        restart: :transistent,
        max_children: max,
        max_restarts: 0
      )

    TaskManager.start_link(max: max, task_supervisor: supervisor)
  end

  test "ensure maximum is respected" do
    max = 3

    {:ok, supi} =
      Task.Supervisor.start_link(
        strategy: :one_for_one,
        restart: :transistent,
        max_children: max,
        max_restarts: 0
      )

    {:ok, mng} = TaskManager.start_link(max: max, task_supervisor: supi)

    Enum.each(1..10, fn _ ->
      Process.spawn(
        fn ->
          TaskManager.search(:lemming, mng, BlockingProvider, 500)
        end,
        []
      )
    end)

    Enum.each(1..400, fn _ ->
      count = supi |> Task.Supervisor.children() |> length
      assert count <= max
      Process.sleep(10)
    end)

    Logger.flush()
  end

  test "ensure provider.search(query) gets called" do
    expected = ["basic testvalue"]
    {:ok, mng} = start(1)
    actual = TaskManager.search(expected, mng, EchoProvider)
    assert expected == actual
    Logger.flush()
  end

  test "don't hang on unending tasks" do
    {:ok, mng} = start(3)
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

    Logger.flush()
  end

  test "allow multiple managers running at the same time" do
    input_a = ["AAAAAAAAAAAAAa"]
    input_b = ["BBBBBBBBBBbbb"]
    input_c = [12, 23, 34]

    {:ok, mng_a} = start(1)
    {:ok, mng_b} = start(1)
    {:ok, mng_c} = start(1)

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

    Logger.flush()
  end
end
