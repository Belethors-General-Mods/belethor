defmodule WebsiteWeb.PageController do
  use WebsiteWeb, :controller
  alias Website.{Repo, Mod}

  def index(conn, _params) do
    render(conn, "index.html")
  end

  def mods(conn, _params) do
    mods = Repo.all(Mod) |> Repo.preload(:tags)
    render(conn, "mods.html", mods: mods)
  end

end
