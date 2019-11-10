defmodule Common.Schema.Mod do
  @moduledoc """
  Store information about a mod
  """
  use Ecto.Schema

  alias Common.Repo
  alias Common.Schema.ModFile
  alias Common.Schema.ModTag
  alias Common.Utils
  alias Ecto.Changeset
  alias Ecto.Multi

  @derive {Jason.Encoder, only: [:name, :desc, :published, :image, :oldrim, :sse]}
  schema "mod" do
    field(:name, :string)
    field(:desc, :string)
    field(:published, :boolean)
    field(:image, :string)

    embeds_one(:oldrim, ModFile, on_replace: :delete)
    embeds_one(:sse, ModFile, on_replace: :delete)
    many_to_many(:tags, ModTag, join_through: "mods_tags", unique: true)
  end

  def delete!(id) do
    __MODULE__
    |> Repo.get(id)
    |> Repo.delete!()
  end

  def changeset(mod, changes \\ %{}) do
    mod
    |> Changeset.cast(changes, [:name, :desc, :published, :image])
    |> optional_cast_embed(changes, :oldrim)
    |> optional_cast_embed(changes, :sse)
    |> Changeset.validate_required([:name, :published])
    |> Changeset.unique_constraint(:name)
  end

  defp optional_cast_embed(cs, change, name, opts \\ []) do
    if Map.has_key?(change, Atom.to_string(name)) do
      # create/update the modfile
      Changeset.cast_embed(cs, name, opts)
    else
      # delete the modfile
      Changeset.put_embed(cs, name, opts)
    end
  end
end
