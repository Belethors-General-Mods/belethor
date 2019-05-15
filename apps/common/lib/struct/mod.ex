defmodule Common.Struct.Mod do
  @moduledoc """
  Represents a mod.
  """
  alias Common.Struct.Mod

  @enforce_keys [:name, :desc, :published]
  defstruct [
    :name,
    :desc,
    :published,
    :sse,
    :oldrim,
    :image,
    :tags
  ]

  @typedoc "typespec for a mod"
  @type t :: %Mod{}

  def validate(%Mod{name: nil}) do
    {:error, :empty}
  end

  def validate(%Mod{desc: nil}) do
    {:error, :empty}
  end

  def validate(%Mod{published: nil}) do
    {:error, :empty}
  end

  def validate(%Mod{}) do
    :ok
  end
end
