defmodule Common.Mod do

  @enforce_keys [:name, :description, :published]
  defstruct [
    :name, :description, :published,
    :sse, :oldrim, :images, :tags
  ]


  @typedoc """
  TODO
  """
  @type t :: %__MODULE__{}


end
