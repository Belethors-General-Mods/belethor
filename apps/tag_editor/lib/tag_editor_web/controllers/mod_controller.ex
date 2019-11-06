defmodule TagEditorWeb.ModController do
  use TagEditorWeb, :controller
  require Logger

  alias Common.Repo
  alias Common.Schema.Mod
  alias Common.Schema.ModFile
  alias Common.Schema.ModList
  alias Ecto.Changeset

  def all(conn, %{}) do
    render(conn, "all.html", mod: Repo.all(Mod)) #TODO add paging
  end

  def view(conn, %{"id" => id}) do
    mod = Repo.get(Mod, id)
    changeset = Changeset.change(mod)
    action = Routes.mod_path(conn, :update, mod.id)
    daction = Routes.mod_path(conn, :delete, mod.id)
    render(conn, "edit.html", mod: mod, changeset: changeset, action: action, delete: daction)
  end

  def new(conn, %{}) do
    mod = %Mod{}
    changeset = Changeset.change(mod)
    action = Routes.mod_path(conn, :create)
    render(conn, "edit.html", mod: mod, changeset: changeset, action: action)
  end

  def create(conn, %{"mod" => changes}) do
    m = Mod.changeset(%Mod{}, changes)

    #TODO check validation stuff [like call Ecto.Changeset.validate ;) ]
    Repo.insert!(m)

    redirect(conn, to: "/mod/")
  end

  def update(conn, %{"id" => id, "mod" => changes}) do
    IO.puts inspect changes, pretty: true
    Mod
    |> Repo.get(id)
    |> Mod.changeset(changes)
    |> Repo.update!

    #TODO check validation stuff [like call Ecto.Changeset.validate ;) ]

    redirect(conn, to: "/mod/")
  end

  def delete(conn, %{"id" => id}) do
    Mod.delete!(id)
    redirect(conn, to: "/mod/")
  end

end
