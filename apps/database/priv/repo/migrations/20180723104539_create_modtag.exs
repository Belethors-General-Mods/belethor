defmodule Database.Repo.Migrations.CreateModTag do
  use Ecto.Migration

  def change do
    create table(:mod_tag) do
      add :name, :string
      add :desc, :string
    end
  end
end
