defmodule Common.StructValidTest do
  use ExUnit.Case

  alias Common.Struct.Image

  test "Image.validate: check 'full' error" do
    full = %Image{data: "jlkdsfj", url: "jlksdjf"}
    assert Image.validate(full) == {:error, :full}
  end

  test "Image.validate: check invalid data" do
    data_wrong = %Image{data: :nope}
    assert Image.validate(data_wrong)
  end

  test "Image.validate: check invalid url" do
    assert Image.validate(%Image{}) == {:error, :empty}
  end

  test "Image.validate: check valid url" do
    valid1 = %Image{url: "jlksdjf"}
    assert Image.validate(valid1) == :ok
  end

  test "Image.validate: check valid data" do
    valid2 = %Image{data: "jlkdsfj"}
    assert Image.validate(valid2) == :ok
  end
end
