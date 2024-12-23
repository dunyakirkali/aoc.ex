defmodule Aoc.Day23 do
  use Memoize

  @doc """
      iex> "priv/day23/example.txt" |> Aoc.Day23.input() |> Aoc.Day23.part1()
      7
  """
  def part1(connctions) do
    connctions
    |> sets()
    |> Enum.filter(fn [a, b, c] ->
      String.starts_with?(a, "t") or String.starts_with?(b, "t") or String.starts_with?(c, "t")
    end)
    |> Enum.count()
  end

  @doc """
      iex> "priv/day23/example2.txt" |> Aoc.Day23.input() |> Aoc.Day23.part2()
      "co,de,ka,ta"
  """
  def part2(connctions) do
    connctions
    |> to_graph()
    |> Graph.cliques()
    |> Enum.reduce([], fn current, longest ->
      if length(current) > length(longest) do
        current
      else
        longest
      end
    end)
    |> Enum.sort()
    |> Enum.join(",")
  end

  @doc """
      iex> "priv/day23/example.txt" |> Aoc.Day23.input() |> Aoc.Day23.sets()
      [
        ["qp", "td", "wh"],
        ["qp", "ub", "kh"],
        ["vc", "tb", "wq"],
        ["vc", "aq", "wq"],
        ["vc", "wq", "ub"],
        ["cg", "aq", "yn"],
        ["td", "yn", "wh"],
        ["td", "tc", "wh"],
        ["ka", "co", "ta"],
        ["ka", "co", "de"],
        ["ka", "ta", "de"],
        ["co", "ta", "de"]
      ]
  """
  def sets(connections) do
    connections
    |> to_graph()
    |> then(fn g ->
      g
      |> Graph.cliques()
      |> Enum.filter(fn c -> Enum.count(c) > 2 end)
      |> Enum.flat_map(fn c -> Comb.combinations(c, 3) end)
      |> Enum.uniq()

      # |> Enum.sort()
    end)
  end

  def to_graph(connections) do
    connections
    |> Enum.reduce(Graph.new(type: :undirected), fn {a, b}, graph ->
      graph
      |> Graph.add_edge(a, b)
    end)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("-", trim: true)
      |> List.to_tuple()
    end)
  end
end
