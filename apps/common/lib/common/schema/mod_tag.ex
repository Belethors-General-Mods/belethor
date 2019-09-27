defmodule Common.Schema.ModTag do
  @moduledoc """
  Stores info about each tag
  """
  use Ecto.Schema

  alias Common.Schema
  alias Common.Struct

  schema "mod_tag" do
    field(:name, :string)
    many_to_many(:mods, Common.Schema.Mod, join_through: "mods_tags", unique: true)
  end

end
