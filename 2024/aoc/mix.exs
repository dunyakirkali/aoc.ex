defmodule Aoc.MixProject do
  use Mix.Project

  def project do
    [
      app: :aoc,
      version: "0.1.0",
      elixir: "~> 1.15",
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
      {:libgraph, "~> 0.16.0"},
      {:nimble_parsec, "~> 1.4.0"},
      {:memoize, "~> 1.4.3"},
      {:benchee, "~> 1.3.1"},
      {:benchee_html, "~> 1.0.1", only: [:dev, :test]},
      {:printex, "~> 1.1.0"},
      {:distance, "~> 1.1.2"},
      {:poison, "~> 6.0.0"},
      {:comb, git: "https://github.com/tallakt/comb.git"},
      {:tensor, "~> 2.0"},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:exprof, "~> 0.2.0"},
      {:flow, "~> 1.2.4"},
      {:deque, "~> 1.2.0"},
      {:cll, "~> 0.2.0"},
      {:nx, "~> 0.5"},
      {:math, "~> 0.7.0"},
      {:giraffe, "~> 0.1.4"}
    ]
  end
end
