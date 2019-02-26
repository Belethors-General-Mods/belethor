defmodule Common.Struct.Image do
  @moduledoc """
  Represents a image.

  only `:data` OR `:url` should be set.
  """
  alias Common.Struct.Image

  defstruct [:data, :url]
  @typedoc "the typespec of an image"
  @type t :: %Image{}

  @doc """
  reason of error can mean:

  | Code        | Meaning           |
  | ------------- | ------------- |
  |`:empty` |  `:url` nor `:data` key present |
  |`{attr, :wrong_type}` | attr has unexpected data type |
  | `:full` | `:url` and `:data` |
  """
  def validate(%Image{url: nil, data: nil}) do
    {:error, :empty}
  end

  def validate(%Image{data: d, url: nil}) do
    if is_binary(d) do
      :ok
    else
      {:error, {:data, :wrong_type}}
    end
  end

  def validate(%Image{data: nil, url: u}) do
    if is_binary(u) do
      :ok
    else
      {:error, {:url, :wrong_type}}
    end
  end

  def validate(%Image{}) do
    {:error, :full}
  end
end
