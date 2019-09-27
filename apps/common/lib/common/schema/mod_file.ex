defmodule Common.Schema.ModFile do
  @moduledoc """
  Store information about a game-version-specific file from a mod
  """
  use Ecto.Schema

  embedded_schema do
    field(:console_compat, :boolean)
    field(:steam, :string)
    field(:nexus, :string)
    field(:bethesda, :string)
  end

end
