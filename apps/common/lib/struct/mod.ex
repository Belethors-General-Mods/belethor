defmodule Common.Mod do
  @moduledoc """
  Represents a mod.
  """
  alias Common.Mod

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

  defimpl Common.Validation, for: Mod do
    def valid?(_mod) do
      true
    end
  end
end
