defmodule Common.Mod.Modfile do
  @moduledoc """
  Represents a mod file somewhere to download.
  """
  alias Common.Mod.Modfile

  @enforce_keys [:console_compat]
  defstruct [:console_compat, :steam, :nexus, :bethesda]

  @typedoc "typespec for a mod"
  @type modfile :: %Modfile{}

  defimpl Common.Validation, for: Modfile do
    def valid?(_mod_file) do
      true
    end
  end
end
