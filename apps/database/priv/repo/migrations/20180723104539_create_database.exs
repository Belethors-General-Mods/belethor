defmodule Database.Repo.Migrations.CreateDatabase do
  use Ecto.Migration

  def change do
    create table(:mod_image) do
      add(:data, :binary)
      add(:url, :string)
    end

    create table(:mod_tag) do
      add(:name, :string)
      add(:desc, :text)
    end

    create table(:mod) do
      add(:name, :string)
      add(:desc, :text)
      add(:published, :boolean)
      add(:oldrim, :map)
      add(:sse, :map)
      add(:image, references(:mod_image))
    end

    create table(:mods_tags) do
      add(:mod_tag_id, references(:mod_tag))
      add(:mod_id, references(:mod))
    end

    create table(:mod_dependencies) do
      add(:requires_id, references(:mod_tag))
      add(:required_by_id, references(:mod))
    end

    create(unique_index(:mod, [:name]))
    create(unique_index(:mod_tag, [:name]))
    create(unique_index(:mod_image, [:data]))
    create(unique_index(:mod_image, [:url]))
    create(unique_index(:mods_tags, [:mod_id, :mod_tag_id]))
    create(unique_index(:mod_dependencies, [:requires_id, :required_by_id]))

    alter table(:mod_image) do
      add(:mod_id, references(:mod))
    end
  end
end
