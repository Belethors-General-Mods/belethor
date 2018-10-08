defmodule Database.Schema.ModFile do
  @moduledoc """
  Store information about a game-version-specific file from a mod
  """
  use Ecto.Schema

  embedded_schema do
    field(:console_compat, :boolean)
    field(:steam, :string)
    field(:nexus, :string)
    field(:bethesda, :string)
    many_to_many(:requires, Database.ModFile, join_through: "mod_dependencies")
    many_to_many(:required_by, Database.ModFile, join_through: "mod_dependencies")
  end
end
