defmodule Aoc.Day12 do
  defmodule Chart do
    def new(input) do
      input
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split("", trim: true)
      end)
      |> Enum.with_index()
      |> Enum.reduce({Map.new(), {0, 0}, {0, 0}}, fn {line, y}, acc ->
        line
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {cell, x}, {c, s, e} ->
          <<v::utf8>> = cell

          case cell do
            "S" -> {Map.put(c, {x, y}, 1), {x, y}, e}
            "E" -> {Map.put(c, {x, y}, 26), s, {x, y}}
            _ -> {Map.put(c, {x, y}, v - 97 + 1), s, e}
          end
        end)
      end)
    end

    def neighbours(map, {x, y}) do
      {width, height} = size(map)

      [{x + 1, y}, {x, y + 1}, {x - 1, y}, {x, y - 1}]
      |> Enum.filter(fn {x, y} ->
        x > -1 and y > -1 and x < width and y < height
      end)
    end

    def size(map) do
      {number_of_cols(map), number_of_rows(map)}
    end

    def number_of_rows(map) do
      map
      |> Map.keys()
      |> Enum.map(fn x ->
        elem(x, 1)
      end)
      |> Enum.max()
      |> Kernel.+(1)
    end

    def number_of_cols(map) do
      map
      |> Map.keys()
      |> Enum.map(fn x ->
        elem(x, 0)
      end)
      |> Enum.max()
      |> Kernel.+(1)
    end
  end

  def new(input) do
    {map, s, e} = Chart.new(input)

    graph =
      map
      |> Enum.reduce(Graph.new(), fn {{x, y}, _}, acc ->
        path = Enum.join([x, y], ":")
        Graph.add_vertex(acc, path)
      end)

    graph =
      map
      |> Enum.reduce(graph, fn {{x, y}, fv}, acc ->
        map
        |> Chart.neighbours({x, y})
        |> Enum.reduce(acc, fn {nx, ny}, acc ->
          from = Enum.join([x, y], ":")
          to = Enum.join([nx, ny], ":")
          tv = Map.get(map, {nx, ny})
          diff = tv - fv

          if diff < 2 do
            Graph.add_edge(acc, from, to)
          else
            acc
          end
        end)
      end)

    {map, graph, s, e}
  end

  def solve({_, graph, s, e}) do
    strtp = Enum.join(Tuple.to_list(s), ":")
    endp = Enum.join(Tuple.to_list(e), ":")

    path = Graph.dijkstra(graph, strtp, endp)

    if path == nil do
      1_000_000
    else
      path
      |> Enum.count()
      |> Kernel.-(1)
    end
  end

  @doc """
      iex> "priv/day12/example.txt" |> Aoc.Day12.input() |> Aoc.Day12.part1()
      31
  """
  def part1(input) do
    input
    |> new()
    |> solve()
  end

  @doc """
      iex> "priv/day12/example.txt" |> Aoc.Day12.input() |> Aoc.Day12.part2()
      29
  """
  def part2(input) do
    input
    |> new()
    |> then(fn {map, graph, _, e} ->
      Map.filter(map, fn {_, v} ->
        v == 1
      end)
      |> Enum.map(fn {s, _} ->
        solve({map, graph, s, e})
      end)
      |> Enum.min()
    end)
  end

  def input(filename) do
    filename
    |> File.read!()
  end
end
