defmodule Database.Mod do
  use Ecto.Schema

  schema "mod" do
    field :name, :string
    field :pic,  :string
    field :desc, :string

    belongs_to :oldrim, Database.Modfile
    belongs_to :sse, Database.Modfile
    many_to_many :tags, Database.ModTag, join_through: "modtags"
  end
end
