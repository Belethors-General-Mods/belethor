defmodule TagEditorWeb.ModListController do
  use TagEditorWeb, :controller

  alias Common.Repo

  def all(conn, %{}) do
    render(conn, "all.html", mod_lists: Repo.all(ModList))
  end

  def view(conn, %{"id" => id}) do
    ml = ModList |> Repo.get(id) |> Repo.preload([:mods])
    tags = []
    render(conn, "edit.html", mod_list: ml, tags: tags)
  end

  def new(conn, %{"id" => _id}) do
    render(conn, "edit.html")
  end

  def create(conn, %{"id" => _id}) do
    render(conn, "edit.html")
  end

  def update(conn, %{"id" => _id}) do
    render(conn, "edit.html")
  end

  def delete(conn, %{"id" => _id}) do
    render(conn, "edit.html")
  end
end
