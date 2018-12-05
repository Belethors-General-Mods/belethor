defmodule Database do
  @moduledoc """
  The internal API module for the database.

  This module makes a point of not requiring knowledge about how the
  database is set up. This is to make it easier to split the db onto
  its own node down the line.
  """
  import Ecto.Query, only: [from: 2]
  alias Ecto.Changeset

  alias Database.Repo
  alias Database.Schema.Mod
  alias Database.Schema.ModFile
  alias Database.Schema.ModImage
  alias Database.Schema.ModTag

  require Logger

  @typedoc """
  A map representation of `Database.Schema.ModFile`.
  """
  @type modfile :: %{
          :console_compat => boolean(),
          optional(:steam) => String.t(),
          optional(:nexus) => String.t(),
          optional(:bethesda) => String.t()
        }

  @typedoc """
  A map representation of `Database.Schema.ModImage`.

  Exactly one of `:data`, `:image` should be present.
  """
  @type image :: %{
          optional(:data) => binary(),
          optional(:url) => String.t()
        }

  @typedoc """
  A map representation of `Database.Schema.ModTag`.
  """
  @type tag :: String.t()

  @typedoc """
  A map representation of `Database.Schema.Mod`.
  """
  @type mod :: %{
          :name => String.t(),
          :description => String.t(),
          :published => boolean(),
          optional(:sse) => modfile(),
          optional(:oldrim) => modfile(),
          optional(:images) => list(image()),
          optional(:tags) => list(tag())
        }

  @doc """
  Adds or updates a mod in the database.
  """
  @spec add_mod(mod :: mod()) :: :ok | {:error, reason :: term()}
  def add_mod(mod) do
    if mod_exists?(mod.name) do
      update_mod(mod.name, mod)
    else
      insert_mod(mod)
    end
  end

  @doc """
  Get a mod as a map by either its name or id.

  `:id` must be an integer greater than 0.

  Both `:id` and `:name` are unique keys. See `Database.Schema.Mod` for
  more info.
  """
  @spec get_mod(name_or_id :: String.t() | integer()) ::
          {:error, reason :: atom()}
          | {:ok, mod()}
  def get_mod(name_or_id) do
    m =
      case get_mod_raw(name_or_id) do
        {:ok, mod} -> {:ok, Map.from_struct(mod)}
        x -> x
      end

    # Logger.warn(inspect(m))
    m
  end

  @doc """
  Check whether a mod exists with the given name.
  """
  @spec mod_exists?(name :: String.t()) :: boolean()
  def mod_exists?(name) do
    Repo.exists?(
      from(
        m in Mod,
        where: m.name == ^name
      )
    )
  end

  @doc """
  Check whether an image exists with the given url or data.
  """
  @spec image_exists?(image()) :: boolean()
  def image_exists?(%{url: url}) do
    Repo.exists?(
      from(
        i in ModImage,
        where: i.url == ^url
      )
    )
  end

  def image_exists?(%{data: data}) do
    Repo.exists?(
      from(
        i in ModImage,
        where: i.data == ^data
      )
    )
  end

  # -------------- HERE BE DRAGONS --------------

  defp update_mod(mod_name, changes) do
    case get_mod_raw(mod_name) do
      {:ok, mod} ->
        mod
        |> Mod.changeset(changes)
        |> Repo.update!()

      {:error, reason} ->
        {:error, reason}
    end
  rescue
    error ->
      _ = Logger.error("Query raised an error: #{inspect(error)}")
      {:error, error}
  end

  defp insert_mod(mod) do
    # TODO handle images & tags
    # tag_list =
    #   if mod[:tags] != nil do
    #     mod[:tags]
    #   else
    #     []
    #   end
    #
    # tags =
    #   for t <- tag_list do
    #     Repo.get_by(ModTag, name: t)
    #   end

    image_list =
      if mod[:images] != nil do
        mod[:images]
      else
        []
      end

    images =
      for i <- image_list |> Enum.uniq() do
        # Logger.warn(image_exists?(i))
        # Logger.warn(inspect(i))

        if image_exists?(i) do
          c = get_image_raw(i)

          # Logger.error(inspect(c))
          c
        else
          %ModImage{}
          |> ModImage.changeset(i)
        end
      end

    # for i <- images do
    #   # add_image(i)
    # end

    m = Map.merge(mod, %{images: images})

    # Logger.error(inspect(m.tags))

    %Mod{}
    |> Mod.changeset(m)
    # |> Changeset.put_assoc(:tags, tags)
    # |> Changeset.put_assoc(:images, images)
    |> Repo.insert_or_update!()
  end

  defp get_mod_raw(name) when is_binary(name) do
    Repo.get_by(Mod, name: name)
    |> Repo.preload([:tags, :images])
  rescue
    error ->
      _ = Logger.error("Query raised an error: #{inspect(error)}")
      {:error, error}
  else
    nil -> {:error, :not_found}
    m -> {:ok, m}
  end

  defp get_mod_raw(id) when is_integer(id) and id > 0 do
    Repo.get(Mod, id) |> Repo.preload([:tags, :images])
  rescue
    error ->
      _ = Logger.error("Query raised an error: #{inspect(error)}")
      {:error, error}
  else
    nil -> {:error, :not_found}
    m -> {:ok, m}
  end

  defp get_image_raw(%{url: url}) do
    Repo.get_by(ModImage, url: url)
  end

  defp get_image_raw(%{data: data}) do
    Repo.get_by(ModImage, data: data)
  end
end
