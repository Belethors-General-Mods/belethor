defmodule Common.Schema.Mod do
  @moduledoc """
  Store information about a mod

  | Attribute | Meaning           |
  | ------------- |:------------- |
  | `name`        | the mods name |
  | `desc`      | the mods description |
  | `published` | wether the mod should be publicly accessibly |
  | `image` | an url to an image |
  | `sse` | a number of links for its Skyrim Special Edition implementation |
  | `oldrim` | a number of links for the OG Skyrim Engine released in 11.11.2011 |
  | `tags` | the number of tags |
  """
  use Ecto.Schema

  require Logger
  # import Common.Utils, only: [debug: 1]

  alias Common.ModDB
  alias Common.Repo
  alias Common.Schema.ModFile
  alias Common.Schema.ModTag
  alias Ecto.Changeset

  @type id :: term()
  @type t :: %__MODULE__{
          id: id,
          name: String.t(),
          desc: String.t(),
          published: bool,
          image: String.t(),
          sse: ModFile.t() | nil,
          oldrim: ModFile.t() | nil,
          tags: [ModTag.t()] | Ecto.Association.NotLoaded.t()
  }

  @type change :: %{
    optional(:name) => binary(),
    optional(:desc) => binary(),
    optional(:published) => binary(),
    optional(:image) => binary(),
    optional(:sse) => ModFile.change(),
    optional(:oldrim) => ModFile.change()
  }

  @default %{
    desc: "todo: add a description",
    image: "no_image.jpg"
  }

  @derive {Jason.Encoder, only: [:id, :name, :desc, :published, :image, :oldrim, :sse, :tags]}
  schema "mod" do
    field(:name, :string)
    field(:desc, :string)
    field(:published, :boolean)
    field(:image, :string)

    embeds_one(:oldrim, ModFile, on_replace: :delete)
    embeds_one(:sse, ModFile, on_replace: :delete)
    many_to_many(:tags, ModTag,
      join_through: "mods_tags",
      unique: true,
      on_replace: :delete
    )
  end

  @doc false
  def changeset(mod, changes \\ %{}) do
    changing = Map.keys(changes)

    mod
    |> preload()
    |> Changeset.cast(changes, [:name, :desc, :published, :image])
    |> change_modfile(changes, :oldrim)
    |> change_modfile(changes, :sse)
    |> Changeset.put_assoc(:tags, get_tags(changes))
    |> Changeset.validate_required([:name, :desc, :published, :image])
    |> Changeset.unique_constraint(:name)
  end

  @doc """
  Loads data, from other data.
  `mods.tags` is filled, with that.
  """
  @spec preload(mod :: t) :: [ModTag.t]
  def preload(mod) do
    Repo.preload(mod, [:tags])
  end

  @doc """
  Creates a new %Mod to be fed into `Repo.insert!/2` for example.
  Sets default values, if they are not present in the arguments.
  """
  def new(changes \\ %{}) do
    %__MODULE__{} |> changeset(Map.merge(@default, changes))
  end

  defp get_tags(changes) do
    case Map.get(changes, "tags") do
      nil -> []
      tags -> Enum.map(tags, &ModDB.create_tag/1)
    end
  end

  defp change_modfile(cs, change, name, opts \\ []) do
    if Map.has_key?(change, Atom.to_string(name)) do
      # create/update the modfile
      Changeset.cast_embed(cs, name, opts)
    else
      # delete the modfile
      Changeset.put_embed(cs, name, opts)
    end
  end

end
