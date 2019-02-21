defmodule Common.Struct.Modfile do
  @moduledoc """
  Represents a mod file somewhere to download.
  """
  alias Common.Struct.Modfile

  @enforce_keys [:console_compat]
  defstruct [:console_compat, :steam, :nexus, :bethesda]

  @typedoc "typespec for a mod"
  @type modfile :: %Modfile{}

  def validate(%Modfile{console_compat: nil}) do
    {:error, :empty}
  end

  def validate(%Modfile{console_compat: b}) do
    if(is_boolean(b)) do
      :ok
    else
      {:error, {:console_compat, :wrong_type}}
    end
  end
end
