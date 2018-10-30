defmodule DatabaseTest do
  use ExUnit.Case
  use ExUnitProperties
  doctest Database

  # alias Database.Repo
  # alias Database.Schema.Mod
  # alias Database.Schema.ModFile
  # alias Database.Schema.ModImage
  # alias Database.Schema.ModTag

  @test_time Application.get_env(:database, :test_time)
  @test_runs Application.get_env(:database, :test_runs)
  @translations Application.get_env(:database, :tag_translations)

  defp modfile do
    %{:console_compat => StreamData.boolean()}
    |> Map.merge(
      StreamData.optional_map(%{
        :steam => StreamData.string(:ascii),
        :nexus => StreamData.string(:ascii),
        :bethesda => StreamData.string(:ascii)
      })
    )
  end

  defp image do
    StreamData.optional_map(%{
      :data => StreamData.binary(),
      :url => StreamData.string(:ascii)
    })
  end

  defp tag do
    StreamData.member_of(@translations |> Map.keys())
  end

  defp mods do
    %{
      :published? => StreamData.boolean(),
      :name => StreamData.string(:printable),
      :descriptions => StreamData.string(:printable)
    }
    |> Map.merge(
      StreamData.optional_map(%{
        :sse => modfile(),
        :oldrim => modfile(),
        :images => list_of(image()),
        :tags => list_of(tag())
      })
    )
  end

  property "creates mods correctly" do
    check all mod <- mods(),
              max_run_time: @test_time,
              max_runs: @test_runs do
      assert Database.add_mod(mod)
    end
  end
end
