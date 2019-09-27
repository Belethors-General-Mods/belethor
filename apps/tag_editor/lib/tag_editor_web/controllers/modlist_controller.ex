defmodule TagEditorWeb.ModListController do
  use TagEditorWeb, :controller

  # lots of TODO things
  def index(conn, %{"id" => _id}) do
    render(conn, "index.html")
  end

  def new(conn, %{"id" => _id}) do
    render(conn, "index.html")
  end

  def create(conn, %{"id" => _id}) do
    render(conn, "index.html")
  end

  def update(conn, %{"id" => _id}) do
    render(conn, "index.html")
  end

  def delete(conn, %{"id" => _id}) do
    render(conn, "index.html")
  end
end
