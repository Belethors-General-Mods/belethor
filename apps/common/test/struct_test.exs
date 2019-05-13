defmodule Common.StructValidTest do
  use ExUnit.Case

  alias Common.Struct.Image
  alias Common.Struct.Mod
  alias Common.Struct.Modfile
  alias Common.Struct.ModList

  test "Image.validate: check 'full' error" do
    full = %Image{data: "jlkdsfj", url: "jlksdjf"}
    assert Image.validate(full) == {:error, :full}
  end

  test "Image.validate: check invalid data" do
    data_wrong = %Image{data: :nope}
    assert Image.validate(data_wrong)
  end

  test "Image.validate: check invalid url" do
    assert Image.validate(%Image{}) == {:error, :empty}
  end

  test "Image.validate: check valid url" do
    valid1 = %Image{url: "jlksdjf"}
    assert Image.validate(valid1) == :ok
  end

  test "Image.validate: check valid data" do
    valid2 = %Image{data: "jlkdsfj"}
    assert Image.validate(valid2) == :ok
  end

  test "Mod.validate: enforced keys != nil" do
    n = %Mod{name: nil, description: "d", published: "p"}
    d = %Mod{name: "n", description: nil, published: "p"}
    p = %Mod{name: "n", description: "d", published: nil}
    assert Mod.validate(n) == {:error, :empty}
    assert Mod.validate(d) == {:error, :empty}
    assert Mod.validate(p) == {:error, :empty}
  end

  test "Modfile.validate: console_compate is always a boolean" do
    empty = %Modfile{console_compat: nil}
    assert Modfile.validate(empty) == {:error, :empty}

    wt = %Modfile{console_compat: "true"}
    assert Modfile.validate(wt) == {:error, {:console_compat, :wrong_type}}

    ok = %Modfile{console_compat: true}
    assert Modfile.validate(ok) == :ok
  end

  test "ModList.validate: test" do
    ok = %ModList{ name = "test", mods = []}
    assert :ok == ModList.validate(ok)

    noname = %ModList { mods = []}
    assert {:error, :empty} == ModList.validate(noname)

    nomods = %ModList { name = "name"}
    assert {:error, :empty} == ModList.validate(nomods)
  end
end

