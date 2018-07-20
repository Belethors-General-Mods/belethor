defmodule TagEditorWeb.PageController do
  use TagEditorWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
