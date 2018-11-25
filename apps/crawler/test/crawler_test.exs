defmodule CrawlerTest do
  use ExUnit.Case
  alias Crawler

  doctest Crawler

  test "has Crawler.Application started the provider managers and supervisors" do
    :ok = Application.ensure_started(:crawler)

    # bad test, becaus it relies on the order of supervisor children
    assert match?(
             [
               {Crawler.Bethesda.TaskManager, _, :worker,
                [Crawler.TaskManager]},
               {Crawler.Bethesda.Supervisor, _, :worker, [Task.Supervisor]},
               {Crawler.Nexus.TaskManager, _, :worker, [Crawler.TaskManager]},
               {Crawler.Nexus.Supervisor, _, :worker, [Task.Supervisor]},
               {Crawler.Steam.TaskManager, _, :worker, [Crawler.TaskManager]},
               {Crawler.Steam.Supervisor, _, :worker, [Task.Supervisor]}
             ],
             Supervisor.which_children(Crawler.Supervisor)
           )
  end
end
