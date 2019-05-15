defmodule Database.Schema.ModFile do
  @moduledoc """
  Store information about a game-version-specific file from a mod
  """
  use Ecto.Schema

  alias Database.Schema
  alias Common.Struct

  embedded_schema do
    field(:console_compat, :boolean)
    field(:steam, :string)
    field(:nexus, :string)
    field(:bethesda, :string)
  end

  def struct2schema(%Struct.ModFile{} = struct) do
    %Schema.ModFile {
      console_compat: struct.console_compat,
      steam: struct.steam,
      nexus: struct.nexus,
      bethesda: struct.bethesda
    }
  end

  def schema2struct(%Schema.ModFile{} = schema) do
    %Struct.ModFile {
      console_compat: schema.console_compat,
      steam: schema.steam,
      nexus: schema.nexus,
      bethesda: schema.bethesda
    }
  end

end
