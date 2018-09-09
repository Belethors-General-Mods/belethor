defmodule Database.Repo.Migrations.CreateMod do
  use Ecto.Migration

  def change do
    create table(:mod) do
      add :name, :string
      add :desc, :string
      add :pic,  :string
    end
  end
end
