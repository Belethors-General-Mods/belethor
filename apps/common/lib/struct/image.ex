defmodule Common.Struct.Image do
  @moduledoc """
  Represents a image.

  only `:data` OR `:url` should be set.
  """
  alias Common.Struct.Image

  defstruct [:data, :url]
  @typedoc "the typespec of an image"
  @type t :: %Image{}

end
