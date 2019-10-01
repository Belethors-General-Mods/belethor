defmodule TagEditorWeb.ModController do
  use TagEditorWeb, :controller
  require Logger

  alias Common.Repo
  alias Common.Schema.Mod
  alias Common.Schema.ModFile
  alias Common.Schema.ModList

  def all(conn, %{}) do
    render(conn, "all.html", mod: Repo.all(Mod))
  end

  def view(conn, %{"id" => id}) do
    mod = Repo.get(Mod, id)
    changeset = Mod.changeset(mod)
    action = Routes.mod_path(conn, :update, mod.id)
    render(conn, "edit.html", mod: mod, changeset: changeset, action: action)
  end

  def new(conn, %{}) do
    mod = %Mod{}
    changeset = Mod.changeset(mod)
    action = Routes.mod_path(conn, :create)
    render(conn, "edit.html", mod: mod, changeset: changeset, action: action)
  end

  def create(conn, %{"mod" => changes}) do
    cs = Mod.changeset(%Mod{}, changes)

    #TODO check validation stuff [like call Ecto.Changeset.validate ;) ]
    if cs.valid?, do: Repo.insert!(cs)

    redirect(conn, to: "/mod/")
  end

  def update(conn, %{"id" => id, "mod" => changes}) do
    cs = Mod
    |> Repo.get(id)
    |> Mod.changeset(changes)

    #TODO check validation stuff [like call Ecto.Changeset.validate ;) ]
    if cs.valid?, do: Repo.update!(cs)

    redirect(conn, to: "/mod/")
  end

  def delete(conn, %{"id" => id}) do
    Repo.delete!(Mod, id)
    redirect(conn, to: "/mod/")
  end

end
