defmodule Common.Schema.ModTag do
  @moduledoc """
  Stores info about each tag

  | Attribute | Meaning           |
  | ---------|:------------- |
  | `name` | the tag's name |
  | `mods`  | mods described with this tag |
  """
  use Ecto.Schema

  alias Common.Schema.Mod

  @type id :: term()
  @type t :: %__MODULE__{
    id: id,
    name: String.t(),
    mods: [Mod.t()] | Ecto.Association.NotLoaded.t()
  }

  @derive {Jason.Encoder, only: [:id, :name]}
  schema "mod_tag" do
    field(:name, :string)

    many_to_many(:mods, Mod,
      join_through: "mods_tags",
      unique: true,
      on_replace: :delete
    )
  end

  @doc false
  def changeset(tag, attrs) do
    import Ecto.Changeset

    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
