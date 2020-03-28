defmodule Common.ModDB do
  @moduledoc """
  The Mods context.
  """

  require Logger
  import Common.Utils, only: [debug: 1]

  alias Common.Repo
  alias Common.Schema.Mod
  # alias Common.Schema.ModFile
  alias Common.Schema.ModTag
  alias Common.Schema.Modlist
  alias Common.Utils

  alias Ecto.Changeset

  ### ====== TAGS ======

  @doc """
  Returns the list of _all_ tags.
  """
  @spec list_tags() :: [ModTag.t()]
  def list_tags, do: Repo.all(ModTag)

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the ModTag does not exist.
  """
  @spec get_tag!(id :: ModTag.id()) :: ModTag.t()
  def get_tag!(id), do: Repo.get!(ModTag, id)

  @doc """
  Creates a tag.
  """
  @spec create_tag(change :: Utils.unclean_change()) ::
          {:ok, ModTag.t()} | {:error, Changeset.t(Mod.t())}
  def create_tag(change \\ %{}) do
    clean_ch = ModTag.clean_changes(change)

    %ModTag{}
    |> ModTag.changeset(clean_ch)
    |> Repo.insert()
  end

  ### ====== MODS ======

  @doc """
  Returns the list of _all_ mods.
  """
  @spec list_mods() :: [Mod.t()]
  def list_mods, do: Repo.all(Mod)
  # TODO page this stuff, Repo.stream/2 seems useful

  @doc """
  Creates a mod.
  """
  @spec create_mod(change :: Utils.change()) :: {:ok, Mod.t()} | {:error, Changeset.t(Mod.t())}
  def create_mod(change \\ %{}) do
    cs =
      change
      |> Mod.clean_changes()
      |> Mod.new()

    if cs.valid? do
      Repo.insert(cs)
    else
      {:error, cs}
    end
  end

  @doc """
  Gets a single mod. The tags are not loaded, to access `mod.tags` do `Repo.preload(mod, [:tags])` before try to access them.

  Raises `Ecto.NoResultsError` if the ModTag does not exist.
  """
  @spec get_mod!(id :: Mod.id()) :: Mod.t()
  def get_mod!(id), do: Repo.get!(Mod, id)

  @doc """
  Updates a mod.
  """
  @spec update_mod(mod :: Mod.t(), change :: Utils.unclean_change()) ::
          {:ok, Mod.t()} | {:error, Changeset.t(Mod.t())}
  def update_mod(%Mod{} = mod, change) do
    clean_change = Mod.clean_changes(change)

    mod
    |> Mod.changeset(clean_change)
    |> Repo.update()
  end

  @doc """
  Deletes a mod.
  """
  @spec delete_mod(Mod.t()) :: {:ok, Mod.t()} | {:error, Changeset.t(Mod.t())}
  def delete_mod(%Mod{} = mod), do: Repo.delete(mod)

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking mod changes.
  """
  @spec change_mod(Mod.t()) :: Changeset.t(Mod.t())
  def change_mod(%Mod{} = mod), do: Mod.changeset(mod, %{})

  ### ====== MOD LISTS ======

  @doc """
  Returns the list of _all_ modlists.
  """
  @spec list_modlists() :: [Modlist.t()]
  def list_modlists(), do: Repo.all(Modlist)
  # TODO needs paging

  @spec get_modlist!(id :: Modlist.id()) :: Modlist.t()
  def get_modlist!(id), do: Repo.get!(Modlist, id)

  @doc """
  Return the list of _all_ modlist.
  """
  @spec add_mod_to_list(list :: Modlist.t(), mod :: Mod.t()) ::
          {:ok, Modlist.t()} | {:error, Changeset.t(Modlist.t())}
  def add_mod_to_list(list, mod) do
    _cs = Modlist.changeset(list)
    # TODO
    {:ok, list}
  end

  @doc """
  Creates a modlist.
  """
  @spec create_modlist(change :: Utils.unclean_change()) ::
          {:ok, Modlist.t()} | {:error, Changeset.t(Modlist.t())}
  def create_modlist(change \\ %{}) do
    change
    |> Modlist.clean_changes()
    |> Modlist.new()
    |> Repo.insert()
  end

  @doc """
  Gets a single modlist.

  Raises `Ecto.NoResultsError` if the ModTag does not exist.
  """
  @spec get_modlist!(id :: Modlist.id()) :: Modlist.t()
  def get_modlist!(id), do: Repo.get!(Modlist, id)

  @doc """
  Updates a modlist.
  """
  @spec update_modlist(Modlist.t(), change :: Utils.unclean_change()) ::
          {:ok, Modlist.t()} | {:error, Changeset.t(Modlist.t())}
  def update_modlist(%Modlist{} = modlist, change) do
    modlist
    |> Modlist.changeset(change)
    |> Repo.update()
  end

  @doc """
  Deletes a modlist.
  """
  @spec delete_modlist(Modlist.t()) :: {:ok, Modlist.t()} | {:error, Changeset.t(Modlist.t())}
  def delete_modlist(%Modlist{} = modlist), do: Repo.delete(modlist)

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking modlist changes.
  """
  @spec change_modlist(modlist :: Modlist.t()) :: Changeset.t(Modlist.t())
  def change_modlist(%Modlist{} = modlist), do: Modlist.changeset(modlist, %{})
end
