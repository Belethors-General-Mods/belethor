defmodule Common.ModTest do
  use Common.DataCase

  alias Common.Schema.Mod
  alias Ecto.Changeset

  describe "Mod" do
    test "Mod.new/1 with only a name as argument will return a valid changeset" do
      assert (%Changeset{} = cs) = Mod.new(%{name: "test mod"})
      assert cs.valid?
    end

    test "Mod.clean_changes/1 empty argument" do
      assert %{} == Mod.clean_changes(%{})
    end

    test "Mod.clean_changes/1 some arguments" do
      input = %{
        "name" => "test name",
        "desc" => "test desc",
        "published" => "false"
      }
      expected = %{
        name: "test name",
        desc: "test desc",
        published: false
      }
      assert expected == Mod.clean_changes(input)
    end
  end
end
