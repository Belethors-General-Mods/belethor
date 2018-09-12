defmodule Database.NexusMod do
  use Ecto.Schema

  schema "nexus_mod" do
    field :name, :string
    field :desc, :string
    field :pic,  :string
    field :url,  :string
    field :rim,  :integer
  end

end
