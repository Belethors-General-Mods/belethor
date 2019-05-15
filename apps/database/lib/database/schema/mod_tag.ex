defmodule Database.Schema.ModTag do
  @moduledoc """
  Stores info about each tag
  """
  use Ecto.Schema

  alias Database.Schema
  alias Common.Struct

  schema "mod_tag" do
    field(:name, :string)
    many_to_many(:mods, Database.Schema.Mod, join_through: "mods_tags", unique: true)
  end

  def struct2schema(string) when is_bitstring(string) do
    %Schema.ModTag{ name: string }
  end

  def schema2struct(%Schema.ModTag{} = schema) do
    schema.name
  end
end
