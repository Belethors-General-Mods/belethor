defmodule Website.Repo.Migrations.CreateModModtagRelation do
  use Ecto.Migration

  def change do
    alter table(:mod) do
      add :oldrim_id, references(:modfile)
      add :sse_id, references(:modfile)
    end
  end
end
