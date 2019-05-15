defmodule Common.Struct.ModList do
  @moduledoc """
  Represents a mod.
  """
  alias Common.Struct.ModList

  @enforce_keys [:name, :mods]
  defstruct [
    :name,
    :desc,
    :mods
  ]

  @typedoc "typespec for a mod"
  @type t :: %ModList{}

  def validate(%ModList{name: nil}) do
    {:error, :empty}
  end

  def validate(%ModList{mods: nil}) do
    {:error, :empty}
  end

  def validate(%ModList{}) do
    :ok
  end
end
