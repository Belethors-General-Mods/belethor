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
  @tags @translations |> Map.keys()

  defp modfile do
    gen all required <-
              StreamData.fixed_map(%{
                :console_compat => StreamData.boolean()
              }),
            optional <-
              StreamData.optional_map(%{
                :steam => StreamData.string(:ascii),
                :nexus => StreamData.string(:ascii),
                :bethesda => StreamData.string(:ascii)
              }) do
      Map.merge(optional, required)
    end
  end

  defp image do
    StreamData.optional_map(%{
      :data => StreamData.binary(),
      :url => StreamData.string(:ascii)
    })
  end

  defp tag do
    StreamData.member_of(@tags)
  end

  defp mods do
    gen all required <-
              StreamData.fixed_map(%{
                :published => StreamData.boolean(),
                :name => StreamData.string(:printable, min_length: 1),
                :desc => StreamData.string(:printable, min_length: 1)
              }),
            optional <-
              StreamData.optional_map(%{
                :sse => modfile(),
                :oldrim => modfile(),
                :images => list_of(image()),
                :tags => list_of(tag())
              }) do
      Map.merge(optional, required)
    end
  end

  property "creates mods correctly" do
    check all mod <- mods(),
              [:published, :name, :desc] |> Enum.all?(&Map.has_key?(mod, &1)),
              max_run_time: @test_time,
              max_runs: @test_runs do
      assert Database.add_mod(mod)
    end
  end
end
