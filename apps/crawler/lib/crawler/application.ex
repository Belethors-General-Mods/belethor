defmodule Crawler.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application
  require Logger

  def start(_type, _args) do
    # List all child processes to be supervised
    children =
      [
        define_taskmanager(Steam, 3),
        define_taskmanager(Nexus, 3),
        define_taskmanager(Bethesda, 3)
      ]
      |> List.flatten()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Crawler.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # defines a task manager at Crawler.#{name}.TaskManager
  # and its supervisor at Crawler.#{name}.Supervisor
  defp define_taskmanager(name, max_tasks) do
    sup_name = Module.concat([Crawler, name, Supervisor])
    man_name = Module.concat([Crawler, name, TaskManager])

    [
      %{
        id: sup_name,
        start:
          {Task.Supervisor, :start_link,
           [
             [
               strategy: :one_for_one,
               restart: :transistent,
               max_children: max_tasks,
               max_restarts: 0
             ]
           ]}
      },
      %{
        id: man_name,
        start:
          {Crawler.TaskManager, :start_link,
           [
             [
               name: man_name,
               max: max_tasks,
               task_supervisor: sup_name
             ]
           ]}
      }
    ]
  end
end
