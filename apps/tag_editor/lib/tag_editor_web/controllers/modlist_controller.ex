defmodule TagEditorWeb.ModListController do
  use TagEditorWeb, :controller

  alias Common.Repo
  alias Common.Schema.Mod
  alias Common.Schema.ModList

  def all(conn, %{}) do
    render(conn, "all.html", mod_lists: Repo.all(ModList))
  end

  def view(conn, %{"id" => id}) do
    ml = Repo.get(ModList, id) |> Repo.preload([:mods])
    tags = [] #TODO get modlist tags
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
