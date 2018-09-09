defmodule Database.ModTag do
  use Ecto.Schema

  schema "mod_tag" do
    field :name, :string
    many_to_many :mods, Database.Mod, join_through: "modtags"
  end
end
