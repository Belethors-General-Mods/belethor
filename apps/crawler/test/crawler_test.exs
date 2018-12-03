defmodule CrawlerTest do
  use ExUnit.Case
  alias Crawler.Bethesda
  alias Crawler.Nexus
  alias Crawler.Steam

  doctest Crawler

  test "has Crawler.Application started the provider managers and supervisors" do
    :ok = Application.ensure_started(:crawler)

    actual =
      Crawler.Supervisor
      |> Supervisor.which_children()
      |> Enum.map(fn {name, _pid, type, origin} -> {name, type, origin} end)

    assert Enum.member?(actual, {Bethesda.TaskManager, :worker, [Crawler.TaskManager]})
    assert Enum.member?(actual, {Bethesda.Supervisor, :worker, [Task.Supervisor]})
    assert Enum.member?(actual, {Nexus.TaskManager, :worker, [Crawler.TaskManager]})
    assert Enum.member?(actual, {Nexus.Supervisor, :worker, [Task.Supervisor]})
    assert Enum.member?(actual, {Steam.TaskManager, :worker, [Crawler.TaskManager]})
    assert Enum.member?(actual, {Steam.Supervisor, :worker, [Task.Supervisor]})
  end

  test "check if the provider instances are functional" do
    assert Nexus.search("whatever") == {:error, :not_implemented}
    assert Steam.search("whatever") == {:error, :not_implemented}
    assert Bethesda.search("whatever") == {:error, :not_implemented}
  end

end
