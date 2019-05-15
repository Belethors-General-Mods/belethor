alias Database.Repo
alias Database.Schema.Mod
alias Database.Schema.ModTag
alias Database.Schema.ModFile
alias Ecto.Changeset

favi = "/favicon.ico"

modfile_a_sse = %ModFile{console_compat: false, steam: "steam url: sse aaaaaaaaaa"}
modfile_a_oldrim = %ModFile{console_compat: false, nexus: "nexus url: oldrim aaaaaaaa"}
modfile_b_sse = %ModFile{console_compat: true, bethesda: "beths url: bbbbbbbb"}

tag_a = %ModTag{name: "Tag A"} |> Repo.insert!() |> Repo.preload(:mods)
tag_b = %ModTag{name: "Tag B"} |> Repo.insert!() |> Repo.preload(:mods)
tag_c = %ModTag{name: "Tag C"} |> Repo.insert!() |> Repo.preload(:mods)

%Mod{name: "Mod A", desc: "aaaaaaaaaaaaaaa", image: favi, published: false }
|> Repo.insert!()
|> Repo.preload([:tags])
|> Changeset.change()
|> Changeset.put_assoc(:tags, [tag_a, tag_c])
|> Changeset.put_embed(:sse, modfile_a_sse)
|> Changeset.put_embed(:oldrim, modfile_a_oldrim)
|> Repo.update!()

%Mod{name: "Mod B", desc: "bbbbbbbbbbbbbbb", image: favi, published: false}
|> Repo.insert!()
|> Repo.preload([:tags])
|> Changeset.change()
|> Changeset.put_assoc(:tags, [tag_a, tag_b, tag_c])
|> Changeset.put_embed(:sse, modfile_b_sse)
|> Repo.update!()

%Mod{name: "Mod C", desc: "ccccccccccccccc", image: favi, published: false}
|> Repo.insert!()
|> Repo.preload([:tags])
|> Changeset.change()
|> Changeset.put_assoc(:tags, [tag_b])
|> Repo.update!()
