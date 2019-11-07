defmodule Common.Schema.ModFile do
  @moduledoc """
  Store information about a game-version-specific file from a mod
  """
  use Ecto.Schema

  @derive {Jason.Encoder, only: [:console_compat, :nexus, :steam, :bethesda]}
  embedded_schema do
    field(:console_compat, :boolean)
    field(:steam, :string)
    field(:nexus, :string)
    field(:bethesda, :string)
  end

  def changeset(modfile, changes) do
    import Ecto.Changeset
    changes = fix_form(changes)

    modfile
    |> cast(changes, [:console_compat, :steam, :nexus, :bethesda])
    |> validate_required([:console_compat])
    #todo add url constraint
  end

  defp fix_form(changes) do
    cc = Map.has_key?(changes, "console_compat")

    changes
    |> Map.delete("console_compat")
    |> Map.put("console_compat", cc)
  end

end
