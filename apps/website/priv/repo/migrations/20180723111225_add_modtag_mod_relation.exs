defmodule Website.Repo.Migrations.CreateModtagModRelation do
  use Ecto.Migration

  def change do
    create table(:modtags) do
      add :mod_tag_id, references(:mod_tag)
      add :mod_id, references(:mod)
    end
    create unique_index(:modtags, [:mod_id, :mod_tag_id])
  end
end
