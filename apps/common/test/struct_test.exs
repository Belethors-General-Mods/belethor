defmodule Common.StructValidTest do
  use ExUnit.Case

  alias Common.Struct.Image
  alias Common.Validation

  test "valid? image" do
    invalid1 = %Image{data: "jlkdsfj", url: "jlksdjf"}
    invalid2 = %Image{data: nil, url: nil}
    valid1 = %Image{data: nil, url: "jlksdjf"}
    valid2 = %Image{data: "jlkdsfj", url: nil}

    assert !(invalid1 |> Validation.valid?())
    assert !(invalid2 |> Validation.valid?())
    assert valid1 |> Validation.valid?()
    assert valid2 |> Validation.valid?()
  end
end
