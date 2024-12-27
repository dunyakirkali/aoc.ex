defmodule Aoc.Day12 do
  @doc """
      iex> "priv/day12/example.txt" |> Aoc.Day12.input() |> Aoc.Day12.part1()
      140

      iex> "priv/day12/example2.txt" |> Aoc.Day12.input() |> Aoc.Day12.part1()
      772

      iex> "priv/day12/example3.txt" |> Aoc.Day12.input() |> Aoc.Day12.part1()
      1930
  """
  def part1(map) do
    map
    |> to_graph()
    |> solve()
  end

  @doc """
      iex> "priv/day12/example.txt" |> Aoc.Day12.input() |> Aoc.Day12.part2()
      80

      iex> "priv/day12/example3.txt" |> Aoc.Day12.input() |> Aoc.Day12.part2()
      1206
  """
  def part2(map) do
    map
    |> to_graph()
    |> solve2()
  end

  @doc """
  D
      iex> [{3, 2}] |> Aoc.Day12.sides()
      4

  E
      iex> [{0, 0}, {1, 0}, {2, 0}] |> Aoc.Day12.sides()
      4

  B
      iex> [{0, 0}, {1, 0}, {1, 1}, {0, 1}] |> Aoc.Day12.sides()
      4

  A
      iex> [{0, 0}, {1, 0}, {2, 0}, {3, 0}] |> Aoc.Day12.sides()
      4

  C
      iex> [{0, 0}, {0, 1}, {1, 1}, {1, 2}] |> Aoc.Day12.sides()
      8
  """
  def sides(list) do
    list
    |> Enum.map(fn {x, y} ->
      [right, bottom, left, top] =
        {x, y}
        |> neighbors()
        |> Enum.map(fn np -> Enum.member?(list, np) end)

      tl =
        if not (top or left) or (top and left and not Enum.member?(list, {x - 1, y - 1})),
          do: 1,
          else: 0

      tr =
        if not (top or right) or (top and right and not Enum.member?(list, {x + 1, y - 1})),
          do: 1,
          else: 0

      bl =
        if not (bottom or left) or (bottom and left and not Enum.member?(list, {x - 1, y + 1})),
          do: 1,
          else: 0

      br =
        if not (bottom or right) or (bottom and right and not Enum.member?(list, {x + 1, y + 1})),
          do: 1,
          else: 0

      tl + tr + bl + br
    end)
    |> Enum.sum()
  end

  def solve2(graph) do
    graph
    |> groups()
    |> Enum.map(fn group ->
      price2(group)
    end)
    |> Enum.sum()
  end

  def solve(graph) do
    graph
    |> groups()
    |> Enum.map(fn group ->
      price(group)
    end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day12/example.txt" |> Aoc.Day12.input() |> Aoc.Day12.to_graph() |> Aoc.Day12.groups()
      [[{2, 1}, {2, 2}, {3, 2}, {3, 3}], [{0, 0}, {1, 0}, {2, 0}, {3, 0}], [{0, 1}, {0, 2}, {1, 1}, {1, 2}], [{0, 3}, {1, 3}, {2, 3}], [{3, 1}]]
  """
  def groups(graph) do
    # Graph.loop_vertices(graph)
    graph
    |> Graph.vertices()
    |> Enum.map(fn vertex ->
      Graph.reachable(graph, [vertex])
      |> Enum.sort()
    end)
    |> Enum.uniq()
  end

  @doc """
      iex> [{3, 2}, {3, 3}, {2, 3}, {2, 2}] |> Aoc.Day12.area()
      4
  """
  def area(list) do
    Enum.count(list)
  end

  @doc """
  D
      iex> [{3, 2}] |> Aoc.Day12.perimeter()
      4

  E
      iex> [{0, 0}, {1, 0}, {2, 0}] |> Aoc.Day12.perimeter()
      8

  B
      iex> [{0, 0}, {1, 0}, {1, 1}, {0, 1}] |> Aoc.Day12.perimeter()
      8

  A
      iex> [{0, 0}, {1, 0}, {2, 0}, {3, 0}] |> Aoc.Day12.perimeter()
      10

  C
      iex> [{0, 0}, {0, 1}, {1, 1}, {1, 2}] |> Aoc.Day12.perimeter()
      10
  """
  def perimeter(list) do
    msl =
      MapSet.new(list)

    Enum.map(list, fn pos -> neighbors(pos) end)
    |> Enum.map(fn ns ->
      msns = MapSet.new(ns)

      MapSet.difference(msns, msl)
      |> MapSet.to_list()
    end)
    |> Enum.reduce([], fn set, acc ->
      acc ++ set
    end)
    |> Enum.count()
  end

  def price(list) do
    area(list) * perimeter(list)
  end

  def price2(list) do
    area(list) * sides(list)
  end

  @doc """
      iex> "priv/day12/example.txt" |> Aoc.Day12.input() |> Aoc.Day12.plant_types()
      ["A", "B", "C", "D", "E"]
  """
  def plant_types(map) do
    map
    |> Map.values()
    |> Enum.uniq()
    |> Enum.sort()
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
    |> Enum.reduce(Giraffe.Graph.new(type: :undirected), fn {pos, plant}, g ->
      pos
      |> neighbors()
      |> Enum.reduce(Giraffe.Graph.add_vertex(g, pos, plant), fn npos, gg ->
        nchar = Map.get(map, npos, "#")

        if nchar == plant do
          Giraffe.Graph.add_edge(gg, pos, npos)
        else
          gg
        end
      end)
    end)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, row}, acc ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {char, col}, accc ->
        Map.put(accc, {col, row}, char)
      end)
    end)
  end
end
