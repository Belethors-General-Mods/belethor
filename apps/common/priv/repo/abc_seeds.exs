alias Common.Repo
alias Common.Schema.Mod
alias Common.Schema.ModTag
alias Common.Schema.ModFile
alias Common.Schema.ModList
alias Ecto.Changeset

favi = "/pictures/bgm_logo.svg"

modfile_a_sse = %ModFile{console_compat: false, steam: "steam url: sse aaaaaaaaaa"}
modfile_a_oldrim = %ModFile{console_compat: false, nexus: "nexus url: oldrim aaaaaaaa"}
modfile_b_sse = %ModFile{console_compat: true, bethesda: "beths url: bbbbbbbb"}

tag_a = %ModTag{name: "Tag A"} |> Repo.insert!() |> Repo.preload(:mods)
tag_b = %ModTag{name: "Tag B"} |> Repo.insert!() |> Repo.preload(:mods)
tag_c = %ModTag{name: "Tag C"} |> Repo.insert!() |> Repo.preload(:mods)

mod_a = %Mod{name: "Mod A", desc: "aaaaaaaaaaaaaaa", image: favi, published: false }
|> Repo.insert!()
|> Repo.preload([:tags])
|> Changeset.change()
|> Changeset.put_assoc(:tags, [tag_a, tag_c])
|> Changeset.put_embed(:sse, modfile_a_sse)
|> Changeset.put_embed(:oldrim, modfile_a_oldrim)
|> Repo.update!()

mod_b = %Mod{name: "Mod B", desc: "bbbbbbbbbbbbbbb", image: favi, published: false}
|> Repo.insert!()
|> Repo.preload([:tags])
|> Changeset.change()
|> Changeset.put_assoc(:tags, [tag_a, tag_b, tag_c])
|> Changeset.put_embed(:sse, modfile_b_sse)
|> Repo.update!()

mod_c = %Mod{name: "Mod C", desc: "ccccccccccccccc", image: favi, published: false}
|> Repo.insert!()
|> Repo.preload([:tags])
|> Changeset.change()
|> Changeset.put_assoc(:tags, [tag_b])
|> Repo.update!()


%ModList{name: "A B C", desc: "ABC liste :>"}
|> Repo.insert!()
|> Repo.preload([:mods])
|> Changeset.change()
|> Changeset.put_assoc(:mods, [mod_a, mod_b, mod_c])
|> Repo.update!()
