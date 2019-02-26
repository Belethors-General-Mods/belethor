defmodule Website.WebsiteTest do
  use ExUnit.Case

  test "starts and stops normally" do
    assert :ok == Application.stop(:website)
    assert :ok == Application.start(:website)
  end
end
