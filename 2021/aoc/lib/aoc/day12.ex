defmodule Aoc.Day12 do
  use Agent

  def start do
    Agent.start_link(fn -> 0 end, name: __MODULE__)
  end

  @doc """
      iex> input = Aoc.Day12.input("priv/day12/example.txt")
      ...> Aoc.Day12.part1(input)
      10

      iex> input = Aoc.Day12.input("priv/day12/example2.txt")
      ...> Aoc.Day12.part1(input)
      19

      iex> input = Aoc.Day12.input("priv/day12/example3.txt")
      ...> Aoc.Day12.part1(input)
      226
  """
  def part1(input) do
    start()

    do_solve(input, "start", [])

    Agent.get(__MODULE__, & &1)
  end

  defp do_solve(graph, node, acc) do
    if node == "end" do
      Agent.update(__MODULE__, &(&1 + 1))
    else
      small =
        acc
        |> Enum.filter(fn chr ->
          String.upcase(chr) != chr
        end)

      :digraph.out_neighbours(graph, node)
      |> Kernel.--(small)
      |> Enum.map(fn n ->
        do_solve(graph, n, [node | acc])
      end)
    end
  end

  @doc """
      iex> input = Aoc.Day12.input("priv/day12/example.txt")
      ...> Aoc.Day12.part2(input)
      36

      iex> input = Aoc.Day12.input("priv/day12/example2.txt")
      ...> Aoc.Day12.part2(input)
      103

      iex> input = Aoc.Day12.input("priv/day12/example3.txt")
      ...> Aoc.Day12.part2(input)
      3509
  """
  def part2(input) do
    start()

    do_solve2(input, "start", [])

    Agent.get(__MODULE__, & &1)
  end

  defp do_solve2(graph, node, acc) do
    if node == "end" do
      Agent.update(__MODULE__, &(&1 + 1))
    else
      cont =
        acc
        |> Enum.filter(fn chr ->
          String.downcase(chr) == chr
        end)
        |> Enum.frequencies()
        |> Map.values()
        |> Enum.member?(2)

      visited =
        if cont do
          acc
          |> Enum.filter(fn chr ->
            String.downcase(chr) == chr
          end)
        else
          []
        end

      :digraph.out_neighbours(graph, node)
      |> Kernel.--(visited)
      |> Kernel.--(["start"])
      |> Enum.map(fn n ->
        do_solve2(graph, n, [node | acc])
      end)
    end
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, "-", trim: true)
    end)
    |> then(fn input ->
      graph =
        input
        |> Enum.reduce(:digraph.new(), fn [from, to], acc ->
          :digraph.add_vertex(acc, from)
          :digraph.add_vertex(acc, to)
          acc
        end)

      input
      |> Enum.reduce(graph, fn [from, to], acc ->
        :digraph.add_edge(acc, from, to)
        :digraph.add_edge(acc, to, from)
        acc
      end)
    end)
  end
end
