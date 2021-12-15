defmodule Aoc.Day15 do
  @doc """
      iex> input = Aoc.Day15.input("priv/day15/example.txt")
      ...> Aoc.Day15.part1(input, {10, 10})
      40
  """
  def part1(input, {dx, dy})  do
    graph = graphify(input)

    graph
    |> Graph.dijkstra({0,0}, {dx - 1, dy - 1})
    |> Enum.drop(1)
    |> Enum.map(fn pos ->
      Map.get(input, pos)
    end)
    |> Enum.sum
  end

  def graphify(map) do
    graph = Enum.reduce(map, Graph.new(), fn {{x, y}, _}, acc ->
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
      {x, y + 1},
    ]
  end

  @doc """
      iex> input = Aoc.Day15.input("priv/day15/example.txt")
      ...> Aoc.Day15.part2(input, {10,10})
      315
  """
  def part2(input, {dx, dy}) do
    expanded =
      input
      |> expand({dx, dy})

    graph =
      expanded
      |> graphify()

    graph
    |> Graph.dijkstra({0,0}, {5 * dx - 1, 5 * dy - 1})
    |> Enum.drop(1)
    |> Enum.map(fn pos ->
      Map.get(expanded, pos)
    end)
    |> Enum.sum
  end

  def expand(map, {dx, dy}) do
    0..4
    |> Enum.reduce(map, fn xe, acc ->
      0..4
      |> Enum.reduce(acc, fn ye, acc ->
        Enum.reduce(map, acc, fn {{x, y}, val}, acc ->
          md = xe + ye
          nv =
            if val + md >= 10 do
              rem(val + md - 1, 9) + 1
            else
              val + md
            end

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
