defmodule Aoc.Day20 do
  use Memoize

  @doc """
      iex> "priv/day20/example.txt" |> Aoc.Day20.input() |> Aoc.Day20.part1()
      0
  """
  def part1({start, desti, map}) do
    dists =
      map
      |> to_graph()
      |> Graph.dijkstra(start, desti)
      |> Enum.with_index()
      |> Enum.reduce(map, fn {pos, index}, acc ->
        Map.put(acc, pos, index)
      end)

    roads =
      map
      |> Enum.filter(fn {_, c} -> c == "." end)

    roads
    |> Stream.flat_map(fn {{fx, fy}, _} ->
      for {{tx, ty}, _} <- roads,
          manhattan_distance(fx, fy, tx, ty) == 2,
          do: Map.get(dists, {tx, ty}) - Map.get(dists, {fx, fy})
    end)
    |> Enum.count(&(&1 > 100))
  end

  def part2({start, desti, map}) do
    dists =
      map
      |> to_graph()
      |> Graph.dijkstra(start, desti)
      |> Enum.with_index()
      |> Enum.reduce(map, fn {pos, index}, acc ->
        Map.put(acc, pos, index)
      end)

    roads =
      map
      |> Enum.filter(fn {_, c} -> c == "." end)

    roads
    |> Stream.flat_map(fn {{fx, fy}, _} ->
      for {{tx, ty}, _} <- roads,
          manhattan_distance(fx, fy, tx, ty) <= 20,
          do: {{tx, ty}, {fx, fy}}
    end)
    |> Enum.uniq()
    |> Enum.map(fn {{fx, fy}, {tx, ty}} ->
      Map.get(dists, {tx, ty}) - Map.get(dists, {fx, fy}) - manhattan_distance(fx, fy, tx, ty) + 1
    end)
    |> Enum.count(&(&1 > 100))
  end

  def manhattan_distance(x1, y1, x2, y2) do
    abs(x1 - x2) + abs(y1 - y2)
  end

  def neighbors({x, y}) do
    [
      {x + 1, y},
      {x, y + 1},
      {x - 1, y},
      {x, y - 1}
    ]
  end

  def to_graph(map) do
    map
    |> Enum.reduce(Graph.new(type: :directed), fn {pos, char}, g ->
      if char == "." do
        pos
        |> neighbors()
        |> Enum.filter(fn np ->
          Map.get(map, np, "#") == "."
        end)
        |> Enum.reduce(Graph.add_vertex(g, pos), fn npos, gg ->
          gg
          |> Graph.add_edge(pos, npos)
          |> Graph.add_edge(npos, pos)
        end)
      else
        g
      end
    end)
  end

  def input(filename) do
    map =
      filename
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.split("", trim: true)
        |> Enum.with_index()
        |> Enum.map(fn {char, x} ->
          {{x, y}, char}
        end)
      end)
      |> Enum.into(%{})

    {start, _} = Enum.find(map, fn {_, char} -> char == "S" end)
    {desti, _} = Enum.find(map, fn {_, char} -> char == "E" end)

    {start, desti, map |> Map.put(start, ".") |> Map.put(desti, ".")}
  end
end
