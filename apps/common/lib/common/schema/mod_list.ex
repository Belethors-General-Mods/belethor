defmodule Common.Schema.ModList do
  @moduledoc """
  Stores lists of mods
  """
  use Ecto.Schema

  schema "mod_list" do
    field(:name, :string)
    field(:desc, :string)
    many_to_many(:mods, Common.Schema.Mod, join_through: "mods_mod_lists", unique: true)
  end
end
