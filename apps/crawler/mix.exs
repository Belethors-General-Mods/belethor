defmodule Crawler.MixProject do
  use Mix.Project

  def project do
    [
      app: :crawler,
      version: "0.1.0",
      build_path: "../../_build",
      config_path: "../../config/config.exs",
      deps_path: "../../deps",
      lockfile: "../../mix.lock",
      elixir: "~> 1.7",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {Crawler.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:common, in_umbrella: true},
      {:httpoison, "~> 1.5"},
      {:floki, "~> 0.20"},
      {:gen_stage, "~> 0.14"}
    ]
  end
end
