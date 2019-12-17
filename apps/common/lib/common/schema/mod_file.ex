defmodule Common.Schema.ModFile do
  @moduledoc """
  Store information about a game-version-specific file from a mod

  | Attribute | Meaning           |
  | ------------- |:------------- |
  | `nexus`     | a link to the files on nexusmods.com |
  | `steam`   | a link to the files on the steam workshop |
  | `bethedsa` | a link to the bethesda mod store |
  | `console_compat` | a boolean, if this mod can run on a console |
  """

  use Ecto.Schema

  @type t :: %__MODULE__{
    id: term(),
    steam: String.t(),
    nexus: String.t(),
    bethesda: String.t(),
    console_compat: bool
  }

  @valid_changes %{}

  @derive {Jason.Encoder, only: [:console_compat, :nexus, :steam, :bethesda]}
  embedded_schema do
    field(:console_compat, :boolean)
    field(:steam, :string)
    field(:nexus, :string)
    field(:bethesda, :string)
  end

  def changeset(modfile, changes) do
    import Ecto.Changeset

    modfile
    |> cast(changes, [:console_compat, :steam, :nexus, :bethesda])
    |> validate_required([:console_compat])

    # TODO add url constraint
  end
end
