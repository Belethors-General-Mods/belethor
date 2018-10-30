defmodule Database do
  @moduledoc """
  Documentation for Database.
  """

  alias Database.Repo
  alias Database.Schema.Mod
  alias Database.Schema.ModFile
  alias Database.Schema.ModImage
  alias Database.Schema.ModTag

  @type modfile :: %{
          :console_compat => boolean(),
          optional(:steam) => String.t(),
          optional(:nexus) => String.t(),
          optional(:bethesda) => String.t()
        }

  @type image :: %{
          optional(:data) => binary(),
          optional(:url) => String.t()
        }

  @type tag :: String.t()

  @type mod :: %{
          :name => String.t(),
          :description => String.t(),
          :published? => boolean(),
          optional(:sse) => modfile(),
          optional(:oldrim) => modfile(),
          optional(:images) => list(image()),
          optional(:tags) => list(tag())
        }

  @spec add_mod(mod :: mod()) :: :ok | {:error, reason :: term()}
  def add_mod(mod) do
    %Mod{}
    |> Mod.changeset(mod)
    |> Repo.insert!()
  end
end
