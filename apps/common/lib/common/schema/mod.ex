defmodule Common.Schema.Mod do
  @moduledoc """
  Store information about a mod
  """
  use Ecto.Schema
  alias Common.Schema

  schema "mod" do
    field(:name, :string)
    field(:desc, :string)
    field(:published, :boolean)
    field(:image, :string)

    embeds_one(:oldrim, Schema.ModFile)
    embeds_one(:sse, Schema.ModFile)
    many_to_many(:tags, Schema.ModTag, join_through: "mods_tags", unique: true)
  end

end
