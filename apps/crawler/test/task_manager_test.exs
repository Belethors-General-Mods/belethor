defmodule TaskManagerTest do
  use ExUnit.Case
  require Logger

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
    {:ok, mng} = Crawler.TaskManager.start_link(1)
    result = Crawler.TaskManager.search(input, mng, EchoProvider)
    assert result == input
  end

  test "don't hang on unending tasks" do
    {:ok, mng} = Crawler.TaskManager.start_link(3)
    input = ["unending testvalue"]

    genserver_timeout = 500
    task_timeout = 800

    block = fn ->
      {exit_reason, _} = catch_exit do
        Crawler.TaskManager.search(:lemming, mng, BlockingProvider, genserver_timeout)
      end
      assert :timeout == exit_reason
      :ok
    end

    valid = fn ->
      Crawler.TaskManager.search(input, mng, EchoProvider, genserver_timeout)
    end

    queue = [block, block, block, valid]
    expected = [:ok, :ok, :ok, input]
    actual = Enum.map(queue, &Task.async/1) |> Enum.map(fn t ->
      Task.await t, task_timeout
    end)

    assert expected == actual

  end

  test "allow multiple managers running at the same time" do
    inputa = ["inputA"]
    inputb = ["inputB"]
    inputc = [12,23,34]

    {:ok, mngA} = Crawler.TaskManager.start_link(1)
    {:ok, mngB} = Crawler.TaskManager.start_link(1)
    {:ok, mngC} = Crawler.TaskManager.start_link(1)

    request = fn input, mng ->
      fn -> Crawler.TaskManager.search(input, mng, EchoProvider) end
    end

    queue = [request.(inputa, mngA), request.(inputb, mngB), request.(inputc, mngC)]
    result = Enum.map(queue, &Task.async/1) |> Enum.reverse |> Enum.map(&Task.await/1)

    assert result == [inputc, inputb, inputa]

  end

end
