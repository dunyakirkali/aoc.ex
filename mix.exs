defmodule Aoc.MixProject do
  use Mix.Project

  def project do
    [
      app: :aoc,
      version: "0.1.0",
      elixir: "~> 1.9",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:nimble_parsec, "~> 0.2"},
      {:memoize, "~> 1.2"},
      {:benchee, "~> 0.11", only: [:dev, :test]},
      {:benchee_html, "~> 1.0", only: [:dev, :test]},
      {:drawille, "~> 0.0.1"},
      {:distance, "~> 0.2.1"},
      {:poison, "~> 3.1"},
      {:comb, git: "https://github.com/tallakt/comb.git"}
    ]
  end
end
