defmodule Database.Repo.Migrations.NexusMod do
  use Ecto.Migration

  def change do
    create table(:nexus_mod) do
      add :name, :string
      add :desc, :string, size: 1024
      add :pic,  :string
      add :url,  :string
      add :rim,  :integer
    end
  end
end
