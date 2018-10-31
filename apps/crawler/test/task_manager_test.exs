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
      :timer.sleep(:infinite)
      query
    end
  end


  test "basic test ensure provider.search(query) gets called" do
    input = ["testvalue"]
    {:ok, mng} = Crawler.TaskManager.start_link(1)
    result = Crawler.TaskManager.search(input, mng, EchoProvider)
    assert result == input
  end

  test "don't hang on unending tasks" do
    {:ok, mng} = Crawler.TaskManager.start_link(2)
    input = ["testvalue"]

    block = fn ->
      {exit_reason, _} = catch_exit(Crawler.TaskManager.search(3000, mng, BlockingProvider, 1000))
      assert :timeout == exit_reason
      :ok
    end

    valid = fn ->
      Crawler.TaskManager.search(input, mng, EchoProvider)
    end

    queue = [block, block, block, valid]
    expected = [:ok, :ok, :ok, input]
    actual = Enum.map(queue, &Task.async/1) |> Enum.map(&Task.await/1)

    assert expected == actual

  end

  test "allow multiple managers running at the same time"

end
