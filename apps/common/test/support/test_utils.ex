defmodule Common.TestUtils do
  import ExUnit.Assertions

  def assert_purelist(list, module) do
    assert is_list(list)

    Enum.each(list, fn el ->
      assert is_map(el)
      assert Map.has_key?(el, :__struct__)
      assert Map.get(el, :__struct__) == module
    end)
  end
end
