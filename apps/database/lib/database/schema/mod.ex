defmodule Database.Schema.Mod do
  @moduledoc """
  Store information about a mod
  """
  use Ecto.Schema
  import Ecto.Changeset

  @tags Map.keys(Application.get_env(:database, :tag_translations))

  schema "mod" do
    field(:name, :string)
    field(:desc, :string)
    field(:published, :boolean)

    embeds_one(:oldrim, Database.Schema.ModFile, on_replace: :update)
    embeds_one(:sse, Database.Schema.ModFile, on_replace: :update)

    many_to_many(:images, Database.Schema.ModImage,
      join_through: "mods_images",
      unique: true
    )

    many_to_many(:tags, Database.Schema.ModTag, join_through: "mods_tags", unique: true)
  end

  def changeset(record, params \\ %{}) do
    record
    |> cast(params, [:name, :desc, :published])
    |> cast_embed(:oldrim)
    |> cast_embed(:sse)
    |> validate_required([:name, :desc, :published])
    |> unique_constraint(:name)
  end
end
