defmodule Database.Repo.Migrations.CreateModfile do
  use Ecto.Migration

  def change do
    create table(:modfile) do
      add :console_compat, :boolean
      add :steam, :string
      add :nexus, :string
      add :bethesda, :string
    end
  end
end
