defmodule Belethor.MixProject do
  @moduledoc false
  use Mix.Project

  # major.minor.patch-docs
  @version "0.0.1-1"

  def project do
    [
      version: @version,
      name: "Belethor's General Mods",
      homepage_url: "http://bgm.tetrarch.co",
      apps_path: "apps",
      aliases: aliases(),
      deps: deps(),
      docs: docs(),
      dialyzer: dialyzer(),
      start_permanent: Mix.env() == :prod,
      test_coverage: [tool: ExCoveralls]
    ]
  end

  defp dialyzer do
    plt =
      case Mix.env() do
        # this fixes a failure when dialyxir is run in a test env
        :test ->
          [:ex_unit]

        _ ->
          []
      end

    [
      plt_add_apps: plt,
      flags: [
        :unmatched_returns,
        :error_handling,
        :race_conditions,
        :no_opaque,
        :underspecs
      ]
    ]
  end

  defp docs do
    ignored =
      case Mix.env() do
        :prod -> [:database, :tag_editor, :crawler, :website]
        _ -> []
      end

    [
      main: "readme",
      api_reference: Mix.env() != :prod,
      # source_ref: "v#{@version}",
      source_url: "https://github.com/Belethors-General-Mods/belethor",
      # logo: "guides/assets/images/bgm_white_64.png",
      ignore_apps: ignored,
      extra_section: "GUIDES",
      extras: [
        "README.md": [title: "README"],
        "guides/test.md": [title: "Test Document"],
        "guides/curation/submitting_a_mod.md": [title: "Submitting a Mod"],
        "guides/modding/advanced/MO1_reference.md": [title: "MO1 Reference"],
        "guides/modding/what_tools_do_i_need.md": [title: "What Tools Do I Need?"],
        "guides/website/search/search_reference.md": [title: "Search Reference"],
        "guides/website/website_overview.md": [title: "Website Overview"]
      ],
      groups_for_extras: [
        Website: Path.wildcard("guides/website/*.md"),
        Searching: Path.wildcard("guides/website/search/*.md"),
        Modding: Path.wildcard("guides/modding/*.md"),
        "Advanced Modding": Path.wildcard("guides/modding/advanced/*.md"),
        "Mod Curation": Path.wildcard("guides/curation/*.md")
      ]
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  defp deps do
    [
      # {:ex_doc, "~> 0.19", runtime: false, only: [:dev, :prod]},
      {:ex_doc,
       git: "https://github.com/elixir-lang/ex_doc",
       ref: "5c5acfac61a311ec4fb61a42d956075bcfddbc44",
       runtime: false,
       only: [:dev, :prod]},
      {:credo, "~> 0.10", runtime: false, only: [:dev, :test]},
      {:dialyxir, ">= 1.0.0-rc.3", runtime: false, only: [:dev, :test]},
      {:distillery, "~> 2.0", runtime: false},
      {:excoveralls, "~> 0.10", runtime: false, only: :test}
    ]
  end

  defp aliases do
    [
      digest: "cmd --app website --app tag_editor mix phx.digest"
    ]
  end
end
