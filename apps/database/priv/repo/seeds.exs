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

alias Database.{Repo, Mod, ModTag, Modfile}
alias Ecto.Changeset

mod_a = Repo.insert!(%Mod{ name: "Mod A", desc: "aaaaaaaaaaaaaaa", pic: "/favicon.ico" }) |> Repo.preload([:tags, :oldrim, :sse])
mod_b = Repo.insert!(%Mod{ name: "Mod B", desc: "bbbbbbbbbbbbbbb", pic: "/favicon.ico" }) |> Repo.preload([:tags, :oldrim, :sse])
mod_c = Repo.insert!(%Mod{ name: "Mod C", desc: "ccccccccccccccc", pic: "/favicon.ico" }) |> Repo.preload([:tags, :oldrim, :sse])


tag_a = Repo.insert!(%ModTag{ name: "Tag A" }) |> Repo.preload(:mods)
tag_b = Repo.insert!(%ModTag{ name: "Tag B" }) |> Repo.preload(:mods)
tag_c = Repo.insert!(%ModTag{ name: "Tag C" }) |> Repo.preload(:mods)

file_a_sse = Repo.insert!(%Modfile{ console_compat: :false, steam: "steam url: sse aaaaaaaaaa" })
file_a_oldrim = Repo.insert!(%Modfile{ console_compat: :false, nexus: "nexus url: oldrim aaaaaaaa"})
file_b_sse = Repo.insert!(%Modfile{ console_compat: :true, bethesda: "beths url: bbbbbbbb"})

mod_a = Changeset.change(mod_a) |> Changeset.put_assoc(:sse, file_a_sse)
                                |> Changeset.put_assoc(:oldrim, file_a_oldrim)
                                |> Repo.update!()

mod_b = Changeset.change(mod_b) |> Changeset.put_assoc(:sse, file_b_sse) |> Repo.update!()

mod_a = Changeset.change(mod_a) |> Changeset.put_assoc(:tags, [tag_a, tag_c])        |> Repo.update!()
mod_b = Changeset.change(mod_b) |> Changeset.put_assoc(:tags, [tag_a, tag_b, tag_c]) |> Repo.update!()
mod_c = Changeset.change(mod_c) |> Changeset.put_assoc(:tags, [tag_b])               |> Repo.update!()
