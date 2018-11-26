defmodule CrawlerTest do
  use ExUnit.Case
  alias Crawler

  doctest Crawler

  test "has Crawler.Application started the provider managers and supervisors" do
    :ok = Application.ensure_started(:crawler)

    actual =
      Supervisor.which_children(Crawler.Supervisor)
      |> Enum.map(fn {name, _pid, type, origin} -> {name, type, origin} end)

    assert Enum.member?(
             actual,
             {Crawler.Bethesda.TaskManager, :worker, [Crawler.TaskManager]}
           )

    assert Enum.member?(
             actual,
             {Crawler.Bethesda.Supervisor, :worker, [Task.Supervisor]}
           )

    assert Enum.member?(
             actual,
             {Crawler.Nexus.TaskManager, :worker, [Crawler.TaskManager]}
           )

    assert Enum.member?(
             actual,
             {Crawler.Nexus.Supervisor, :worker, [Task.Supervisor]}
           )

    assert Enum.member?(
             actual,
             {Crawler.Steam.TaskManager, :worker, [Crawler.TaskManager]}
           )

    assert Enum.member?(
             actual,
             {Crawler.Steam.Supervisor, :worker, [Task.Supervisor]}
           )
  end
end
