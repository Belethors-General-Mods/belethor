# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Website.Repo.insert!(%Website.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Database.Schema.Repo
alias Database.Schema.Mod
alias Database.Schema.ModTag
alias Database.Schema.Modfile
alias Ecto.Changeset

mod_a =
  %Mod{name: "Mod A", desc: "aaaaaaaaaaaaaaa", pic: "/favicon.ico"}
  |> Repo.insert!()
  |> Repo.preload([:tags, :oldrim, :sse])

mod_b =
  %Mod{name: "Mod B", desc: "bbbbbbbbbbbbbbb", pic: "/favicon.ico"}
  |> Repo.insert!()
  |> Repo.preload([:tags, :oldrim, :sse])

mod_c =
  %Mod{name: "Mod C", desc: "ccccccccccccccc", pic: "/favicon.ico"}
  |> Repo.insert!()
  |> Repo.preload([:tags, :oldrim, :sse])

tag_a = %ModTag{name: "Tag A"} |> Repo.insert!() |> Repo.preload(:mods)
tag_b = %ModTag{name: "Tag B"} |> Repo.insert!() |> Repo.preload(:mods)
tag_c = %ModTag{name: "Tag C"} |> Repo.insert!() |> Repo.preload(:mods)

file_a_sse =
  %Modfile{console_compat: false, steam: "steam url: sse aaaaaaaaaa"}
  |> Repo.insert!()

file_a_oldrim =
  %Modfile{console_compat: false, nexus: "nexus url: oldrim aaaaaaaa"}
  |> Repo.insert!()

file_b_sse =
  %Modfile{console_compat: true, bethesda: "beths url: bbbbbbbb"}
  |> Repo.insert!()

mod_a =
  mod_a
  |> Changeset.change()
  |> Changeset.put_assoc(:sse, file_a_sse)
  |> Changeset.put_assoc(:oldrim, file_a_oldrim)
  |> Repo.update!()

mod_b =
  mod_b
  |> Changeset.change()
  |> Changeset.put_assoc(:sse, file_b_sse)
  |> Repo.update!()

mod_a =
  mod_a
  |> Changeset.change()
  |> Changeset.put_assoc(:tags, [tag_a, tag_c])
  |> Repo.update!()

mod_b =
  mod_b
  |> Changeset.change()
  |> Changeset.put_assoc(:tags, [tag_a, tag_b, tag_c])
  |> Repo.update!()

mod_c =
  mod_c
  |> Changeset.change()
  |> Changeset.put_assoc(:tags, [tag_b])
  |> Repo.update!()
