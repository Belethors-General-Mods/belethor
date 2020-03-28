defmodule Common.Schema.Modlist do
  @moduledoc """
  Stores lists of mods

  | Attribute | Meaning     |
  | ---------|:------------- |
  | `name` | the tag's name |
  | `desc` | a description about what the list is all about |
  | `mods` | mods described with this tag |
  """
  use Ecto.Schema

  alias Common.Schema.Mod
  alias Common.Utils

  @type id :: term()
  @type t :: %__MODULE__{
          id: id,
          name: String.t(),
          desc: String.t(),
          mods: [Mod.t()] | Ecto.Association.NotLoaded.t()
        }

  @type change :: %{
          optional(:name) => String.t(),
          optional(:desc) => String.t()
        }

  @valid_changes %{
    "name" => {:name, &Utils.to_string/1}
  }

  @default %{
    desc: "TODO, add a description"
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

  @spec clean_changes(unclean :: Common.unclean_change()) :: change()
  def clean_changes(unclean) do
    Utils.clean_changes(unclean, @valid_changes)
  end

  @doc """
  Creates a new %Modlist to be fed into `Repo.insert!/2` for example.
  Sets default values, if they are not present in the arguments.
  """
  @spec new(changes :: change()) :: t()
  def new(changes) do
    %__MODULE__{} |> changeset(Map.merge(@default, changes))
  end

  @doc false
  def changeset(tag, attrs \\ %{}) do
    import Ecto.Changeset

    tag
    |> cast(attrs, [:name, :desc])
    |> validate_required([:name, :desc])
  end
end
