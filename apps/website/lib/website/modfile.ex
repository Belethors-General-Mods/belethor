defmodule Website.Modfile do
  use Ecto.Schema

  schema "modfile" do
    has_one :mod, Website.Mod
    field :console_compat, :boolean
    field :steam, :string
    field :nexus, :string
    field :bethesda, :string
#   one_to_many requirements, []
  end
end
