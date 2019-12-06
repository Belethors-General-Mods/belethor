defmodule Common.Schema.ModList do
  @moduledoc """
  Stores lists of mods

  | Attribute | Meaning           |
  | ---------|:------------- |
  | `name` | the tag's name |
  | `mods` | mods described with this tag |
  """
  use Ecto.Schema

  @type id :: term()
  @type t :: %__MODULE__{
    id: id,
    name: String.t(),
    mods: [Mod.t()] | Ecto.Association.NotLoaded.t()
  }

  schema "mod_list" do
    field(:name, :string)
    field(:desc, :string)
    many_to_many(:mods, Common.Schema.Mod, join_through: "mods_mod_lists", unique: true)
  end

end
