defmodule Database.Modfile do
  use Ecto.Schema

  schema "modfile" do
    has_one :mod, Database.Mod
    field :console_compat, :boolean
    field :steam, :string
    field :nexus, :string
    field :bethesda, :string
#   one_to_many requirements, []
  end
end
