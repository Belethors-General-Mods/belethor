defmodule Database.Schema.Mod do
  @moduledoc """
  Store information about a mod
  """
  use Ecto.Schema

  schema "mod" do
    field(:name, :string)
    field(:desc, :string)
    field(:published, :boolean)
    field(:image, :string)

    embeds_one(:oldrim, Database.Schema.ModFile)
    embeds_one(:sse, Database.Schema.ModFile)
    many_to_many(:tags, Database.Schema.ModTag, join_through: "mods_tags", unique: true)
  end
end
