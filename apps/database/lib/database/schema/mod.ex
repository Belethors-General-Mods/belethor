defmodule Database.Schema.Mod do
  @moduledoc """
  Store information about a mod
  """
  use Ecto.Schema

  schema "mod" do
    field(:name, :string)
    field(:desc, :string)
    field(:published, :boolean)

    embeds_one(:oldrim, Database.ModFile)
    embeds_one(:sse, Database.ModFile)
    has_many(:image, Database.ModImage)
    many_to_many(:tags, Database.ModTag, join_through: "mods_tags", unique: true)
  end
end
