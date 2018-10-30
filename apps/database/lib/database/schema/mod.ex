defmodule Database.Schema.Mod do
  @moduledoc """
  Store information about a mod
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "mod" do
    field(:name, :string)
    field(:desc, :string)
    field(:published, :boolean)

    embeds_one(:oldrim, Database.Schema.ModFile)
    embeds_one(:sse, Database.Schema.ModFile)
    has_many(:image, Database.Schema.ModImage)
    many_to_many(:tags, Database.Schema.ModTag, join_through: "mods_tags", unique: true)
  end

  def changeset(record, params \\ :empty) do
    record
    |> cast(params, [:name, :desc, :published])
    |> cast_embed(:oldrim)
    |> cast_embed(:sse)
  end
end
