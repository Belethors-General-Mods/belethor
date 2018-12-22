defmodule Common.Struct.Modfile do
  @moduledoc """
  Represents a mod file somewhere to download.
  """
  alias Common.Struct.Modfile

  @enforce_keys [:console_compat]
  defstruct [:console_compat, :steam, :nexus, :bethesda]

  @typedoc "typespec for a mod"
  @type modfile :: %Modfile{}

end
