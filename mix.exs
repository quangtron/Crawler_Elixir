defmodule Crawler.MixProject do
  use Mix.Project

  def project do
    [
      app: :crawler,
      version: "0.1.0",
      elixir: "~> 1.12",
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
      {:crawly, "~> 0.13.0"},
      {:floki, "~> 0.26.0"},
      {:json, "~> 1.4"}
    ]
  end
end
