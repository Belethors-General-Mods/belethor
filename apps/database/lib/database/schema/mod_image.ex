defmodule Database.Schema.ModImage do
  @moduledoc """
  Stores images as either links or binary blobs (or both?)
  """
  use Ecto.Schema

  schema "mod_image" do
    field(:data, :binary)
    field(:url, :string)

    belongs_to(:mod, Database.Schema.Mod)
  end
end
