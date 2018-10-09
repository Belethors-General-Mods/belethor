defmodule WebsiteWeb.PageController do
  use WebsiteWeb, :controller
  alias Database.Repo

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def mods(conn, _params) do
    mods =
      Database.Schema.Mod
      |> Repo.all()
      |> Repo.preload(:tags)

    render(conn, "mods.html", mods: mods)
  end
end
