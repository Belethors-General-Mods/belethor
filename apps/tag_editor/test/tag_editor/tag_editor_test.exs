defmodule TagEditor.TagEditorTest do
  use ExUnit.Case

  test "starts and stops normally" do
    assert :ok == Application.stop(:tag_editor)
    assert :ok == Application.start(:tag_editor)
  end
end
