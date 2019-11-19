defmodule Common.Schema.ModTag do
  @moduledoc """
  Stores info about each tag
  """
  use Ecto.Schema

  alias Common.Repo

  require Logger
  import Common.Utils, only: [debug: 1]

  @derive {Jason.Encoder, only: [:id, :name]}
  schema "mod_tag" do
    field(:name, :string)
    many_to_many(:mods, Common.Schema.Mod, join_through: "mods_tags", unique: true, on_replace: :delete)
  end

  def get(%{ "id" => id}) do
    if not is_integer(id) do
      {id, ""} = Integer.parse(id)
    end
    Repo.get(__MODULE__, id)
  end

  def get(%{ "name" => name}) when is_bitstring(name) do
    Repo.get_by(__MODULE__, name: name)
  end

end
