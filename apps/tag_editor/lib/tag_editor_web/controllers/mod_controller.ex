defmodule TagEditorWeb.ModController do
  use TagEditorWeb, :controller

  alias Common.Repo
  alias Common.Schema.Mod
  alias Common.Schema.ModTag
  alias Ecto.Changeset

  # TODO add paging and a search filter to all/2
  def all(conn, %{}) do
    mods = Repo.all(Mod)
    render(conn, "all.html", mods: Enum.map(mods, fn m -> Repo.preload(m, [:tags]) end))
  end

  def all(conn, %{"q" => query}) do
    mods = Repo.all(Mod)

    render(conn, "all.html",
      query: query,
      mods: Enum.map(mods, fn m -> Repo.preload(m, [:tags]) end)
    )
  end

  def view(conn, %{"id" => id}) do
    mod = Mod |> Repo.get(id) |> Repo.preload([:tags])
    all_tags = Repo.all(ModTag)
    changeset = Mod.changeset(mod)
    action = Routes.mod_path(conn, :update, mod.id)
    daction = Routes.mod_path(conn, :delete, mod.id)

    render(conn, "edit.html",
      mod: mod,
      changeset: changeset,
      action: action,
      delete: daction,
      all_tags: all_tags
    )
  end

  def new(conn, %{}) do
    mod = %Mod{} |> Repo.preload([:tags])
    all_tags = Repo.all(ModTag)
    changeset = Changeset.change(mod)
    action = Routes.mod_path(conn, :create)
    render(conn, "edit.html", mod: mod, changeset: changeset, action: action, all_tags: all_tags)
  end

  def create(conn, %{"mod" => changes}) do
    %Mod{}
    |> Mod.changeset(changes)
    |> Repo.insert!()

    redirect(conn, to: "/mod/")
  end

  def update(conn, %{"id" => id, "mod" => changes}) do
    Mod
    |> Repo.get(id)
    |> Mod.changeset(changes)
    |> Repo.update!()

    redirect(conn, to: "/mod/")
  end

  def delete(conn, %{"id" => id}) do
    Mod.delete!(id)
    redirect(conn, to: "/mod/")
  end
end
