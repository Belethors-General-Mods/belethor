defmodule Common.ModTest do
  use Common.DataCase

  alias Common.TestUtils

  alias Common.ModDB
  alias Common.Schema.Mod

  defp get_mod!(id) do
    ModDB.get_mod!(id) |> Mod.preload()
  end

  describe "mod" do
    @valid_attrs %{
      name: "some name",
      desc: "some desc",
      published: false,
      image: "/test.jpg"
    }

    @updated_attrs %{
      name: "some new name",
      desc: "some new desc",
      published: true
    }

    @valid_modfile %{
      sse: %{
        console_compat: true,
        nexus: "test url for nexus"
      }
    }

    @updated_modfile %{
      sse: %{
        console_compat: false,
        nexus: "updated test url for nexus"
      }
    }

    @clean_modfile %{sse: nil}
    @invalid_attrs %{name: nil, published: "nope"}

    test "ModDB.create_mod/1 with valid data, returns a %Mod{}" do
      assert {:ok, %Mod{} = m} = ModDB.create_mod(@valid_attrs)
      assert m.name == "some name"
    end

    test "ModDB.create_mod/1 with invalid data, returns a Changeset" do
      assert {:error, %Ecto.Changeset{}} = ModDB.create_mod(@invalid_attrs)
    end

    test "ModDB.list_mods/0 does return a list of %Mod{}" do
      ModDB.list_mods() |> TestUtils.assert_purelist(Mod)
    end

    test "ModDB CRUD operations on mods" do
      assert {:ok, %Mod{} = m1} = ModDB.create_mod(@valid_attrs)
      id = m1.id
      assert m1 == get_mod!(id)

      assert {:ok, %Mod{} = m2} = ModDB.update_mod(m1, @updated_attrs)
      assert m2 == get_mod!(id)

      assert {:ok, %Mod{} = m3} = ModDB.update_mod(m2, @valid_modfile)
      assert m3 == get_mod!(id)

      assert {:ok, %Mod{} = m4} = ModDB.update_mod(m3, @updated_modfile)
      assert m4 == get_mod!(id)

      assert {:ok, %Mod{} = m5} = ModDB.update_mod(m4, @clean_modfile)
      assert m5 == get_mod!(id)

      # assert changed attributes
      assert m2.name == "some new name"
      assert m2.desc == "some new desc"
      assert m2.published == true

      # assert untoched attribute is still the same
      assert m2.image == "/test.jpg"

      # assert embedded modfile is done correctly
      assert m2.sse == nil
      assert m3.sse.nexus == "test url for nexus"
      assert m4.sse.nexus == "updated test url for nexus"

      # assert deleted modfile
      assert m5.sse == nil

      # assert deleted mod
      assert {:ok, %Mod{}} == ModDB.delete_mod(m5)
    end

    test "ModDB.change_mod/1" do
      assert {:ok, %Mod{} = m} = ModDB.create_mod(@valid_attrs)
      assert (%Ecto.Changeset{} = cs) = ModDB.change_mod(m)
      assert cs.data == m
    end

  end

end
