defmodule TaskManagerTest do
  use ExUnit.Case
  require Logger

  defmodule EchoProvider do
    def search(query) do
      query
    end
  end
    end
  end


  test "basic test ensure provider.search(query) gets called" do
    input = ["testvalue"]
    {:ok, mng} = Crawler.TaskManager.start_link(1)
    result = Crawler.TaskManager.search(input, mng, EchoProvider)
    assert result == input
  end

  @tag capture_log: true
  test "don't hang on unending tasks"

  @tag capture_log: true
  test "allow multiple managers running at the same time"

end
