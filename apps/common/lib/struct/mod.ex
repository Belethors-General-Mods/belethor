defmodule Common.Struct.Mod do
  @moduledoc """
  Represents a mod.
  """
  alias Common.Struct.Mod

  @enforce_keys [:name, :description, :published]
  defstruct [
    :name,
    :description,
    :published,
    :sse,
    :oldrim,
    :images,
    :tags
  ]

  @typedoc "typespec for a mod"
  @type t :: %Mod{}

  def validate(%Mod{name: nil}) do
    {:error, :empty}
  end

  def validate(%Mod{description: nil}) do
    {:error, :empty}
  end

  def validate(%Mod{published: nil}) do
    {:error, :empty}
  end

  def validate(%Mod{}) do
    :ok
  end
end
