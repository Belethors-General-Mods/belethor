defmodule Belethor.MixProject do
  use Mix.Project

  # major.minor.patch-docs
  @version "0.0.1-1"

  def project do
    [
      apps_path: "apps",
      version: @version,
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      test_coverage: [tool: ExCoveralls],
      docs: docs(),
      name: "Belethor's General Mods",
      homepage_url: "http://bgm.tetrarch.co"
    ]
  end

  def docs do
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
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      # {:ex_doc, "~> 0.19", runtime: false},
      {:ex_doc,
       git: "https://github.com/elixir-lang/ex_doc",
       ref: "5c5acfac61a311ec4fb61a42d956075bcfddbc44"},
      {:credo, "~> 0.10", runtime: false, only: [:dev, :test]},
      {:dialyxir, ">= 1.0.0-rc.3", runtime: false, only: [:dev, :test]},
      {:distillery, "~> 1.5", runtime: false},
      {:excoveralls, "~> 0.10", runtime: false, only: :test}
    ]
  end
end
