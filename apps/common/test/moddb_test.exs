defmodule Common.ModDBTest do
  use Common.DataCase

  alias Common.TestUtils
  alias Common.ModDB
  alias Common.Schema.Mod
  alias Common.Schema.ModTag
  alias Common.Schema.Modlist

  describe "Modlist" do

    @valid_mod %{name: "I am here to test mod lists",  published: false}
    @valid_attrs %{name: "some list's name", desc: "some description, what this is about"}
    @valid_update %{name: "just a test"}
    @invalid_attrs %{name: nil}

   test "ModDB.create_modlist/1 with valid data, returns a %Modlist{}" do
      assert {:ok, %Modlist{} = ml1} = ModDB.create_modlist(@valid_attrs)
      assert ml1.name == "some list's name"
    end

    test "ModDB.create_modlist/1 with invalid data, returns a Changeset" do
      assert {:error, %Ecto.Changeset{} = _cs} = ModDB.create_modlist(@invalid_attrs)
    end

    test "ModDB.list_modlists/0 does return a list of %Modlist{}" do
      ModDB.list_modlists() |> TestUtils.assert_purelist(Modlist)
    end

    test "add_mod_to_list/2" do
      assert {:ok, %Mod{} = mod} = ModDB.create_mod(@valid_mod)
      assert {:ok, %Modlist{} = l0} = ModDB.create_modlist(@valid_attrs)
      assert {:ok, l1} = ModDB.add_mod_to_list(mod, l0)
      assert l0.name == l1.name
      assert l0.desc == l1.desc
      assert mod in l1.mods
    end

    test "CRUD Modlist tests" do
      assert {:ok, %Modlist{} = l0 } = ModDB.create_modlist(@valid_attrs)
      id = l0.id
      assert l0 == ModDB.get_modlist!(id)

      assert {:ok, %Modlist{} = l1 } = ModDB.update_modlist(l0, @valid_update)
      assert l1 == ModDB.get_modlist!(id)

      assert {:ok, %Modlist{}} = ModDB.delete_modlist(l1)
      # delete_modlist/1
    end

    test "change_modlist/1" do
      assert {:ok, %Modlist{} = ml} = ModDB.create_modlist(@valid_attrs)
      assert (%Ecto.Changeset{} = cs) = ModDB.change_modlist(ml)
      assert cs.data == ml
    end
  end

  describe "ModTag" do
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
      ModDB.list_tags() |> TestUtils.assert_purelist(ModTag)
    end

  end

  describe "Mod" do

    defp get_mod!(id) do
      ModDB.get_mod!(id) |> Mod.preload()
    end

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
      assert m1 == ModDB.get_mod!(id)

      assert {:ok, %Mod{} = m2} = ModDB.update_mod(m1, @updated_attrs)
      assert m2 == ModDB.get_mod!(id)

      assert {:ok, %Mod{} = m3} = ModDB.update_mod(m2, @valid_modfile)
      assert m3 == ModDB.get_mod!(id)

      assert {:ok, %Mod{} = m4} = ModDB.update_mod(m3, @updated_modfile)
      assert m4 == ModDB.get_mod!(id)

      assert {:ok, %Mod{} = m5} = ModDB.update_mod(m4, @clean_modfile)
      assert m5 == ModDB.get_mod!(id)

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
      assert {:ok, %Mod{}} = ModDB.delete_mod(m5)
    end

    test "ModDB.change_mod/1" do
      assert {:ok, %Mod{} = m} = ModDB.create_mod(@valid_attrs)
      assert (%Ecto.Changeset{} = cs) = ModDB.change_mod(m)
      assert cs.data == m
    end

  end

end
