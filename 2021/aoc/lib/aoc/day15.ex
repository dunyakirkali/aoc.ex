defmodule Aoc.Day15 do
  @doc """
      iex> input = Aoc.Day15.input("priv/day15/example.txt")
      ...> Aoc.Day15.part1(input, {10, 10})
      40
  """
  def part1(input, {dx, dy}) do
    graph = graphify(input)

    graph
    |> Graph.dijkstra({0, 0}, {dx - 1, dy - 1})
    |> Enum.drop(1)
    |> Enum.map(fn pos ->
      Map.get(input, pos)
    end)
    |> Enum.sum()
  end

  def graphify(map) do
    graph =
      Enum.reduce(map, Graph.new(), fn {{x, y}, _}, acc ->
        Graph.add_vertex(acc, {x, y})
      end)

    map
    |> Enum.reduce(graph, fn {pos, val}, acc ->
      pos
      |> neighbors()
      |> Enum.reduce(acc, fn des, acc ->
        tw = Map.get(map, des, 10)
        Graph.add_edge(acc, pos, des, weight: val + tw)
      end)
    end)
  end

  def neighbors({x, y}) do
    [
      {x, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x, y + 1}
    ]
  end

  @doc """
      iex> input = Aoc.Day15.input("priv/day15/example.txt")
      ...> Aoc.Day15.part2(input, {10,10})
      315
  """
  def part2(input, {dx, dy}) do
    expanded = expand(input, {dx, dy})
    graph = graphify(expanded)

    graph
    |> Graph.dijkstra({0, 0}, {5 * dx - 1, 5 * dy - 1})
    |> Enum.drop(1)
    |> Enum.map(fn pos ->
      Map.get(expanded, pos)
    end)
    |> Enum.sum()
  end

  def print(map) do
    IO.puts("")

    height = Map.keys(map) |> Enum.map(fn {x, _} -> x end) |> Enum.max()
    width = Map.keys(map) |> Enum.map(fn {_, y} -> y end) |> Enum.max()

    Enum.map(0..width, fn row ->
      Enum.map(0..height, fn col ->
        pos = {col, row}
        value = Map.get(map, pos, ".")
        to_string(value)
      end)
      |> Enum.intersperse("")
    end)
    |> Enum.join("\n")
    |> IO.puts()

    map
  end

  @doc """
      iex> input = Aoc.Day15.input("priv/day15/example.txt")
      ...> result = Aoc.Day15.input("priv/day15/example_expanded.txt")
      ...> Aoc.Day15.expand(input, {10, 10}) == result
      true
  """
  def expand(map, {dx, dy}) do
    Enum.reduce(0..4, %{}, fn xe, acc ->
      Enum.reduce(0..4, acc, fn ye, acc ->
        Enum.reduce(map, acc, fn {{x, y}, val}, acc ->
          nv = rem(val + xe + ye - 1, 9) + 1
          Map.put(acc, {xe * dx + x, ye * dy + y}, nv)
        end)
      end)
    end)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.graphemes(line)
    end)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, ri}, acc ->
      row
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {col, ci}, acc ->
        Map.put(acc, {ci, ri}, String.to_integer(col))
      end)
    end)
  end
end
