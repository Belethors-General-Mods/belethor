defmodule Common.Modfile do
  @enforce_keys [:console_compat]
  defstruct [:console_compat, :steam, :nexus, :bethesda]

  @typedoc """
  TODO
  """
  @type modfile :: %__MODULE__{}
end
