defmodule TagEditorWeb.ModView do
  use TagEditorWeb, :view

  def render_tags_small(tags) do
    [first | rest] = tags
    Enum.reduce(rest, first.name, fn tag, acc -> acc <> ", " <> tag.name end)
  end

end
