defmodule Database.Schema.Mod do
  @moduledoc """
  Store information about a mod
  """
  use Ecto.Schema

  alias Database.Repo
  alias Database.Schema
  alias Common.Struct

  schema "mod" do
    field(:name, :string)
    field(:desc, :string)
    field(:published, :boolean)
    field(:image, :string)

    embeds_one(:oldrim, Schema.ModFile)
    embeds_one(:sse, Schema.ModFile)
    many_to_many(:tags, Schema.ModTag, join_through: "mods_tags", unique: true)
  end

  def struct2schema(%Struct.Mod{} = struct) do
    %__MODULE__ {
      name: struct.name,
      desc: struct.description,
      published: struct.published,
      sse: Schema.ModFile.from_struct(struct.sse),
      oldrim: Schema.ModFile.from_struct(struct.oldrim),
      tags: Enum.map(struct.tags, &Schema.ModTag.from_struct/1)
    }
  end

  def schema2struct(%__MODULE__{} = schema) do
    schema = Repo.preload(schema, [:tags])
    %Struct.Mod {
      name: schema.name,
      description: schema.desc,
      published: schema.published,
      sse: Schema.ModFile.to_struct(schema.sse),
      oldrim: Schema.ModFile.to_struct(schema.oldrim),
      tags: Enum.map(schema.tags, &Schema.ModTag.to_struct/1)
    }
  end
end
