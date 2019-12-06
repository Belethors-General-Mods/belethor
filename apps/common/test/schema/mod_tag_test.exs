defmodule Common.ModTagTest do
  use Common.DataCase

  alias Common.TestUtils

  alias Common.ModDB
  alias Common.Schema.ModTag

  describe "mod_tag" do
    @valid_attrs %{name: "some name"}
    @invalid_attrs %{name: nil}

    test "ModDB.create_tag/1 with valid data, returns a %ModTag{}" do
      assert {:ok, %ModTag{} = mt1} = ModDB.create_tag(@valid_attrs)
      assert mt1.name == @valid_attrs.name
    end

    test "ModDB.create_tag/1 with invalid data, returns a Changeset" do
      assert {:error, %Ecto.Changeset{}} = ModDB.create_tag(@invalid_attrs)
    end

    test "ModDB.list_tags/0 does return a list of %ModTag{}" do
      ModDB.list_tags()
      |> TestUtils.assert_purelist(Common.Schema.ModTag)
    end
  end
end
