defmodule Common.Schema.ModTag do
  @moduledoc """
  Stores info about each tag

  | Attribute | Meaning           |
  | ---------|:------------- |
  | `name` | the tag's name |
  | `mods`  | mods described with this tag |
  """
  use Ecto.Schema

  alias Common.Repo
  alias Common.Schema.Mod
  alias Common.Utils

  @type id :: term()
  @type t :: %__MODULE__{
          id: id,
          name: String.t(),
          mods: [Mod.t()] | Ecto.Association.NotLoaded.t()
        }

  @valid_changes %{
    "name" => {:name, &Utils.to_string/1}
  }

  @type change :: %{
          # change the name
          optional(:name) => String.t()
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

  @spec clean_changes(unclean :: Common.unclean_change()) :: change()
  def clean_changes(unclean) do
    Utils.clean_changes(unclean, @valid_changes)
  end

  @doc false
  def changeset(tag, attrs) do
    import Ecto.Changeset

    tag
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end

  @doc "TODO write documentation"
  def preload(tag) do
    Repo.preload(tag, [:mods])
  end
end
