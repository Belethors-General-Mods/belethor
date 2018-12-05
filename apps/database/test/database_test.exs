defmodule DatabaseTest do
  use ExUnit.Case
  use ExUnitProperties
  doctest Database

  alias Database.Repo
  # alias Database.Schema.Mod
  # alias Database.Schema.ModFile
  # alias Database.Schema.ModImage
  # alias Database.Schema.ModTag

  @test_time Application.get_env(:database, :test_time)
  @test_runs Application.get_env(:database, :test_runs)
  @translations Application.get_env(:database, :tag_translations)
  @tags @translations |> Map.keys()

  defp uri do
    gen all host <- string(Enum.concat([?a..?z, ?0..?9, [?.]])),
            port <- maybe(member_of(0..65_535)),
            fragment <- maybe(string(:ascii)),
            path <- maybe(string(:ascii)),
            query <- maybe(string(:ascii)),
            scheme <- maybe(string(:ascii)),
            userinfo <- maybe(string(:ascii)),
            authority = if(port != nil, do: "#{host}:#{to_string(port)}", else: "#{host}") do
      %URI{
        authority: authority,
        fragment: fragment,
        host: host,
        path: path,
        port: port,
        query: query,
        scheme: scheme,
        userinfo: userinfo
      }
      |> URI.to_string()
    end
    |> reject_blank()
  end

  defp modfile do
    gen all required <-
              fixed_map(%{
                :console_compat => boolean()
              }),
            optional <-
              optional_map(%{
                :steam => uri(),
                :nexus => uri(),
                :bethesda => uri()
              }) do
      Map.merge(optional, required)
    end
  end

  defp image do
    one_of([
      fixed_map(%{:data => binary(min_length: 1)}),
      fixed_map(%{:url => uri()})
    ])
  end

  defp tag do
    member_of(@tags)
  end

  defp mods do
    gen all required <-
              fixed_map(%{
                :published => boolean(),
                :name => string(:ascii, min_length: 1) |> reject_blank(),
                :desc => string(:ascii, min_length: 1) |> reject_blank()
              }),
            optional <-
              optional_map(%{
                :sse => modfile(),
                :oldrim => modfile(),
                :images => list_of(image()),
                :tags => list_of(tag())
              }) do
      Map.merge(optional, required)
    end
  end

  defp reject_blank(generator) do
    filter(generator, fn x -> not Regex.match?(~r/^\s+$/, x) end)
  end

  defp maybe(generator) do
    one_of([generator, constant(nil)])
  end

  property "creates mods correctly" do
    check all mod <- mods(),
              max_run_time: @test_time,
              max_runs: @test_runs do
      assert m = Database.add_mod(mod) |> Repo.preload([:tags, :images])
      assert {:ok, Map.from_struct(m)} == Database.get_mod(mod.name)
    end
  end

  property "updates mods correctly" do
    check all mod <- mods(),
              new_desc <- string(:ascii, min_length: 1) |> reject_blank(),
              new_desc != mod.desc,
              max_run_time: @test_time,
              max_runs: @test_runs do
      Database.add_mod(mod)
      mod2 = %{mod | desc: new_desc}
      assert m2 = Database.add_mod(mod2) |> Repo.preload([:tags, :images])
      assert {:ok, Map.from_struct(m2)} == Database.get_mod(mod.name)
    end
  end

  property "creates images correctly" do
    check all mod <- mods(),
              Map.has_key?(mod, :images),
              max_run_time: @test_time,
              max_runs: @test_runs do
      Database.add_mod(mod)
      {:ok, m} = Database.get_mod(mod.name)
      assert length(m[:images]) == length(mod[:images])
    end
  end

  property "creates tags correctly" do
    check all mod <- mods(),
              Map.has_key?(mod, :tags),
              max_run_time: @test_time,
              max_runs: @test_runs do
      Database.add_mod(mod)
      {:ok, m} = Database.get_mod(mod.name)
      assert length(m[:tags]) == length(mod[:tags])
    end
  end
end
