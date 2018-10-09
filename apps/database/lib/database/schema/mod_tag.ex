defmodule Database.Schema.ModTag do
  @moduledoc """
  Stores info about each tag
  """
  use Ecto.Schema

  schema "mod_tag" do
    field(:name, :string)
    many_to_many(:mods, Database.Mod, join_through: "mods_tags", unique: true)
  end
end
