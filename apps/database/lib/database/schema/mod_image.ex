defmodule Database.Schema.ModImage do
  @moduledoc """
  Stores images as either links or binary blobs (but not both!)
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "mod_image" do
    field(:data, :binary)
    field(:url, :string)

    many_to_many(:mods, Database.Schema.ModImage,
      join_through: "mods_images",
      unique: true
    )
  end

  def changeset(record, params \\ %{}) do
    record
    |> cast(params, [:data, :url])
    |> validate_one_inclusion([:data, :url])
    |> unique_constraint(:data)
    |> unique_constraint(:url)
  end

  defp validate_one_inclusion(changeset, fields) do
    count =
      fields
      |> Enum.map(&present?(changeset, &1))
      |> Enum.count(fn x -> x end)

    if count == 1 do
      changeset
    else
      add_error(
        changeset,
        hd(fields),
        "Exactly one of these fields must be present: #{inspect(fields)}"
      )
    end
  end

  defp present?(changeset, field) do
    value = get_field(changeset, field)
    value && value != ""
  end
end
