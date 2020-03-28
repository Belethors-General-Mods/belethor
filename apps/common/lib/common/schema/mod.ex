defmodule Common.Schema.Mod do
  @moduledoc """
  Store information about a mod

  | Attribute   | Default Value | Meaning       |
  | ----------- | ------------- | ------------- |
  | `name`      | _no default_  | the mods name |
  | `desc`      | `"todo: add description"` | the mods description |
  | `published` | `false` | wether the mod should be publicly accessibly |
  | `image`     | `no_image.jpg` | an url to an image |
  | `sse`       | `nil` | a number of links for its Skyrim Special Edition implementation |
  | `oldrim`    | `nil`  | a number of links for the OG Skyrim Engine released in 11.11.2011 |
  | `tags`      | `[]` | the number of tags |
  """
  use Ecto.Schema

  require Logger
  # import Common.Utils, only: [debug: 1]

  alias Common.ModDB
  alias Common.Repo
  alias Common.Schema.ModFile
  alias Common.Schema.ModTag
  alias Common.Utils
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
          optional(:oldrim) => ModFile.change(),
          optional(:tags) => tag_change()
        }

  @valid_changes %{
    "name" => {:name, &Utils.to_string/1},
    "desc" => {:desc, &Utils.to_string/1},
    "published" => {:published, &Utils.to_bool/1},
    "image" => {:image, &Utils.to_string/1},
    "sse" => {:sse, &ModFile.clean_changes/1},
    "oldrim" => {:oldrim, &ModFile.clean_changes/1},
    "tags" => {:tags, &__MODULE__.clean_tag_changes/1}
  }

  @default %{
    desc: "todo: add a description",
    image: "no_image.jpg",
    published: false
  }

  @type tag_change :: [{:add, ModTag.t()} | {:delete, ModTag.t()}]
  @valid_type_changes %{
    "add" => {:add, &__MODULE__.ensure_tag!/1},
    "delete" => {:delete, &__MODULE__.ensure_tag!/1}
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

  @doc """
  if you want to to change the tags, this won't be enough.
  """
  @spec clean_changes(unclean :: Common.unclean_change()) :: change()
  def clean_changes(unclean), do: Utils.clean_changes(unclean, @valid_changes)

  @spec clean_tag_changes(unclean :: Common.unclean_change()) :: tag_change()
  def clean_tag_changes(unclean) do
    :todo
  end

  @doc false
  @spec changeset(mod :: t() | Changeset.t(), changes :: change()) :: Changeset.t()
  def changeset(mod, changes \\ %{}) do
    fields = [:name, :desc, :published, :image] |> MapSet.new()
    embeds = [:oldrim, :sse] |> MapSet.new()
    affected = Map.keys(changes) |> MapSet.new()
    affected_embeds = MapSet.intersection(embeds, affected)
    affected_fields = MapSet.intersection(fields, affected)

    # set simple fields into changeset
    cs = Changeset.cast(mod, changes, MapSet.to_list(affected_fields))

    # set the embeded fields
    cs =
      Enum.reduce(
        affected_embeds,
        cs,
        fn embed_key, changeset ->
          case Map.get(changeset.data, embed_key) do
            nil -> Changeset.put_embed(changeset, embed_key, changes[embed_key])
            val -> Changeset.cast_embed(changeset, embed_key)
          end
        end
      )

    # handle the assoc on tags
    if MapSet.member?(affected, :tags) do
      cs =
        Enum.reduce(
          changes.tags,
          cs,
          # Changeset.put_assoc(fucking)
          fn
            {:add, tag} -> :todo
            # remove tag assoc call
            {:delete, tag} -> :todo
          end
        )
    end

    cs
    |> Changeset.validate_required([:name, :desc, :published, :image])
    |> Changeset.unique_constraint(:name)
  end

  @doc """
  Loads data, from other data.
  `mods.tags` is filled, with that.
  """
  @spec preload(mod :: t) :: [ModTag.t()]
  def preload(mod) do
    Repo.preload(mod, [:tags])
  end

  @doc """
  Creates a new %Mod to be fed into `Repo.insert!/2` for example.
  Sets default values, if they are not present in the change argument.
  """
  @spec new(changes :: change()) :: Changeset.t()
  def new(changes \\ %{}) do
    %__MODULE__{} |> changeset(Map.merge(@default, changes))
  end

  defp ensure_tag!(%ModTag{} = t), do: t
  defp ensure_tag!(id), do: ModDB.get_tag!(id)

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
