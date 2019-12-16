defmodule Common.ModlistTest do
  use Common.DataCase

  alias Common.TestUtils

  alias Common.ModDB
  alias Common.Schema.Mod
  alias Common.Schema.Modlist

  describe "mod_list" do

    @valid_mod1 %{name: "I am here to test mod lists",  published: false}
    @valid_attrs %{name: "some list's name"}
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
      assert {:ok, %Mod{} = mod} = ModDB.create_mod(@valid_mod1)
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
end
