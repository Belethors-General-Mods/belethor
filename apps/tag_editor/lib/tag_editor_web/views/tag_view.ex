defmodule TagEditorWeb.TagView do
  use TagEditorWeb, :view

  def render("search.json", %{result: page}) do
    page
  end
end
