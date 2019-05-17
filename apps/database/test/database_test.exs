defmodule DatabaseTest do
  use ExUnit.Case
  doctest Database

  alias Common.Struct

  require Logger

  test "CRUD operations on mod" do
    mod = %Struct.Mod {
      name: "test-mod",
      desc: "just a test mod",
      published: false,
      image: "https://example.org/test.jpg",
      oldrim: %Struct.ModFile {
        console_compat: false,
        steam: "steam url"
      },
      sse: %Struct.ModFile {
        console_compat: false,
        bethesda: "beth download url"
      },
      # "test a" is to be created
      # "Animation" already exists and should be reused
      tags: [ "test a", "Animation" ]
    }

    mod2 = %Struct.Mod { mod |
                         desc: "new description",
                         published: true }

    assert :not_found == Database.read_mod(mod)

    assert :ok == Database.create_mod(mod)
    assert mod == Database.read_mod(mod.name)
    assert :ok == Database.update_mod(mod2)
    assert mod2 == Database.read_mod(mod2.name)
    assert :error  == Database.delete_mod(mod)
    assert :ok == Database.delete_mod(mod2)

    assert :not_found == Database.read_mod(mod)
  end
end
