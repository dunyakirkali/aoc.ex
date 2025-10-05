defmodule Aoc.MixProject do
  use Mix.Project

  def project do
    [
      app: :aoc,
      version: "0.1.0",
      elixir: "~> 1.18",
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
      {:nimble_parsec, "~> 1.4.2"},
      {:memoize, "~> 1.4.3"},
      {:poison, "~> 6.0.0"},
      {:comb, git: "https://github.com/tallakt/comb.git"},
      {:flow, "~> 1.2.4"},
      {:okasaki, "~> 1.0.1"},
      {:cll, "~> 0.2.0"},
      {:math, "~> 0.7.0"}
    ]
  end
end
