defmodule Website.Mod do
  use Ecto.Schema

  schema "mod" do
    field :name, :string
    field :pic,  :string
    field :desc, :string

    belongs_to :oldrim, Website.Modfile
    belongs_to :sse, Website.Modfile
    many_to_many :tags, Website.ModTag, join_through: "modtags"
  end
end
