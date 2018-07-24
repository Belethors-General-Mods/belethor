defmodule Belethor.MixProject do
  use Mix.Project

  def project do
    [
      apps_path: "apps",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Dependencies listed here are available only for this
  # project and cannot be accessed from applications inside
  # the apps folder.
  #
  # Run "mix help deps" for examples and options.
  defp deps do
    [
      {:credo, "~> 0.9", runtime: false},
      {:dialyxir, ">= 1.0.0-rc.3", runtime: false},
      {:distillery, "~> 1.5", runtime: false}
    ]
  end
end
