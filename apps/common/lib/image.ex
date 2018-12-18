defmodule Common.Image do
  @moduledoc """
  Represents a image.

  only `:data` OR `:url` should be set.
  """
  alias Common.Image

  defstruct [:data, :url]
  @typedoc "the typespec of an image"
  @type t :: %Image{}

  defimpl Common.Validation, for: Image do
    def valid?(img) do
      !(img.data == nil) == (img.url == nil)
    end
  end
end
