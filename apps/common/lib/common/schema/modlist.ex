defmodule Common.Schema.Modlist do
  @moduledoc """
  Stores lists of mods

  | Attribute | Meaning     |
  | ---------|:------------- |
  | `name` | the tag's name |
  | `mods` | mods described with this tag |
  """
  use Ecto.Schema

  alias Common.Schema.Mod

  @type id :: term()
  @type t :: %__MODULE__{
    id: id,
    name: String.t(),
    desc: String.t(),
    mods: [Mod.t()] | Ecto.Association.NotLoaded.t()
  }

  @derive {Jason.Encoder, only: [:name, :desc]}
  schema "modlist" do
    field(:name, :string)
    field(:desc, :string)

    many_to_many(:mods, Mod,
      join_through: "mods_modlists",
      unique: true,
      on_replace: :delete
    )
  end

  @doc false
  def changeset(tag, attrs \\ %{}) do
    import Ecto.Changeset
    changing = Map.keys(attrs)

    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

end

