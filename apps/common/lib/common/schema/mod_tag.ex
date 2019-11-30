defmodule Common.Schema.ModTag do
  @moduledoc """
  Stores info about each tag
  """
  use Ecto.Schema

  alias Common.Repo

  @derive {Jason.Encoder, only: [:id, :name]}
  schema "mod_tag" do
    field(:name, :string)

    many_to_many(:mods, Common.Schema.Mod,
      join_through: "mods_tags",
      unique: true,
      on_replace: :delete
    )
  end

  def get(%{"id" => id}) do
    fixed_id =
      if is_integer(id) do
        id
      else
        {fixid, ""} = Integer.parse(id)
        fixid
      end

    Repo.get(__MODULE__, fixed_id)
  end

  def get(%{"name" => name}) when is_bitstring(name) do
    Repo.get_by(__MODULE__, name: name)
  end
end
