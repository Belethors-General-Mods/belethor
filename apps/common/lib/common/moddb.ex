defmodule Common.ModDB do
  @moduledoc """
  The Mods context.
  """

  alias Common.Repo
  alias Common.Schema.Mod
  # alias Common.Schema.ModFile
  alias Common.Schema.ModTag

  alias Ecto.Changeset

  @type change :: %{required(binary()) => term()} | %{required(atom()) => term()} | :invalid,

  ### ====== TAGS ======

  @doc """
  Returns the list of _all_ tags.
  """
  @spec list_tags() :: [ModTag.t]
  def list_tags, do: Repo.all(ModTag)

  @doc """
  Gets a single tag.

  Raises `Ecto.NoResultsError` if the ModTag does not exist.
  """
  @spec get_tag!(id :: ModTag.id) :: ModTag.t
  def get_tag!(id), do: Repo.get!(ModTag, id)

  @doc """
  Creates a tag.
  """
  @spec create_tag(change :: change) :: {:ok, ModTag.t} | {:error, Changeset.t(Mod.t)}
  def create_tag(change \\ %{}) do
    %ModTag{}
    |> ModTag.changeset(change)
    |> Repo.insert()
  end

  ### ====== MODS ======

  @doc """
  Returns the list of _all_ mods.
  """
  @spec list_mods() :: [Mod.t]
  def list_mods, do: Repo.all(Mod)

  @doc """
  Creates a mod.
  """
  @spec create_mod(change :: change) :: {:ok, Mod.t} | {:error, Changeset.t(Mod.t)}
  def create_mod(change \\ %{}) do
    %Mod{}
    |> Mod.changeset(change)
    |> Repo.insert()
  end

  @doc """
  Gets a single mod.

  Raises `Ecto.NoResultsError` if the ModTag does not exist.
  """
  @spec get_mod!(id :: Mod.id) :: Mod.t
  def get_mod!(id), do: Repo.get!(Mod, id)

  @doc """
  Updates a mod.
  """
  @spec update_mod(Mod.t, change :: change) :: {:ok, Mod.t} | {:error, Changeset.t(Mod.t)}
  def update_mod(%Mod{} = mod, change) do
    mod
    |> Mod.changeset(change)
    |> Repo.update()
  end

  @doc """
  Deletes a mod.
  """
  @spec delete_mod(Mod.t) :: {:ok, Mod.t} | {:error, Changeset.t(Mod.t)}
  def delete_mod(%Mod{} = mod), do: Repo.delete(mod)

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking mod changes.
  """
  @spec change_mod(Mod.t) :: Changeset.t(Mod.t)
  def change_mod(%Mod{} = mod), do: Mod.changeset(mod, %{})


  ### ====== MOD LISTS ======

  @doc """
  Returns the list of _all_ modlists.
  """
  @spec list_modlists() :: [ModList.t]
  def list_mods, do: Repo.all(ModList)

  @doc """
  Creates a modlist.
  """
  @spec create_modlist(change :: change) :: {:ok, ModList.t} | {:error, Changeset.t(ModList.t)}
  def create_modlist(change \\ %{}) do
    %ModList{}
    |> ModList.changeset(change)
    |> Repo.insert()
  end

  @doc """
  Gets a single modlist.

  Raises `Ecto.NoResultsError` if the ModTag does not exist.
  """
  @spec get_modlist!(id :: ModList.id) :: ModList.t
  def get_modlist!(id), do: Repo.get!(ModList, id)

  @doc """
  Updates a modlist.
  """
  @spec update_modlist(ModList.t, change :: change) :: {:ok, ModList.t} | {:error, Changeset.t(ModList.t)}
  def update_modlist(%ModList{} = modlist, change) do
    modlist
    |> ModList.changeset(change)
    |> Repo.update()
  end

  @doc """
  Deletes a modlist.
  """
  @spec delete_modlist(ModList.t) :: {:ok, ModList.t} | {:error, Changeset.t(ModList.t)}
  def delete_modlist(%ModList{} = modlist), do: Repo.delete(modlist)

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking modlist changes.
  """
  @spec change_modlist(ModList.t) :: Changeset.t(ModList.t)
  def change_modlist(%ModList{} = modlist), do: ModList.changeset(modlist, %{})

end

