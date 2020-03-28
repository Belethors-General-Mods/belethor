defmodule Common.ModTest do
  use Common.DataCase

  alias Common.Schema.Mod
  alias Ecto.Changeset

  describe "Mod" do
    # reused test data

    @unclean %{
      "name" => "test name",
      "desc" => "test desc",
      "published" => "false"
    }

    @clean %{
      name: "test name",
      desc: "test desc",
      published: false
    }

    @invalid_1 %{
      published: false,
      desc: "hallo, ich bin der Dieter"
    }

    @invalid_2 %{
      name: "invalid test data",
      published: :maybe
    }

    test "Mod.new/1 with only a name as argument will return a valid changeset" do
      assert (%Changeset{} = cs) = Mod.new(%{name: "test mod"})
      assert cs.valid?
    end

    test "Mod.clean_changes/1 empty argument" do
      assert %{} == Mod.clean_changes(%{})
    end

    test "Mod.clean_changes/1 some arguments" do
      assert @clean == Mod.clean_changes(@unclean)
    end

    test "Mod.changeset/2 with invalid data (empty, and thus missing name)" do
      cs =
        %{}
        |> Mod.new()
        |> Mod.changeset(@invalid_1)

      assert not cs.valid?
    end

    test "Mod.changeset/2 with wrong data type" do
      cs =
        %{}
        |> Mod.new()
        |> Mod.changeset(@invalid_2)

      assert not cs.valid?
    end

    test "Mod.changeset/2" do
      # TODO
    end
  end
end
