defmodule DatabaseTest do
  use ExUnit.Case
  doctest Database

  test "greets the world" do
    assert Database.hello() == :world
  end
end
