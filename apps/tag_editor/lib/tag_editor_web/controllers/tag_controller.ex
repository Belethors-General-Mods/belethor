defmodule TagEditorWeb.TagController do
  use TagEditorWeb, :controller

  require Logger
  import Common.Utils, only: [debug: 1]
  import Ecto.Query, only: [from: 2]
  import Ecto.Query.API, only: [like: 2]

  alias Common.Repo
  alias Common.Schema.Mod
  alias Common.Schema.ModTag
  alias Ecto.Changeset

  def all(conn, %{}) do
    # TODO add paging and a search filter
    tags = Repo.all(ModTag)
    render(conn, "all.html", tags: tags)
  end

  def api_search(conn, %{"name" => name}) do
    l = name <> "%"
    q = from(t in ModTag, where: like(t.name, ^l))
    render(conn, "search.json", result: Repo.all(q))
  end

  def api_search(conn, params = %{}) do
    api_search(conn, Map.put(params, "name", ""))
  end
end
