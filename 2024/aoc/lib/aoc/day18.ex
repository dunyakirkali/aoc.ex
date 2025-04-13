defmodule Aoc.Day18 do
  @doc """
      iex> "priv/day18/example.txt" |> Aoc.Day18.input() |> Aoc.Day18.part1({6,6}, 12)
      22
  """
  def part1(lines, desti, len) do
    lines
    |> Enum.take(len)
    |> Enum.map(fn line ->
      line
      |> String.split(",", trim: true)
      |> Enum.map(fn item -> String.to_integer(item) end)
      |> List.to_tuple()
    end)
    |> Enum.map(fn pos -> {pos, "#"} end)
    |> Enum.into(%{})
    # |> draw(desti)
    |> to_graph(desti)
    |> Giraffe.Graph.dijkstra({0, 0}, desti)
    |> Enum.count()
    |> Kernel.-(1)
  end

  @doc """
      iex> "priv/day18/example.txt" |> Aoc.Day18.input() |> Aoc.Day18.part2({6,6})
      "6,1"
  """
  def part2(lines, desti) do
    binary_search(lines, desti, 0, length(lines) - 1)
  end

  def binary_search(list, _target, low, high) when low > high, do: Enum.at(list, high)

  def binary_search(lines, target, low, high) do
    mid = div(low + high, 2)

    mid_has_path =
      lines
      |> Enum.take(mid)
      |> Enum.map(fn line ->
        line
        |> String.split(",", trim: true)
        |> Enum.map(fn item -> String.to_integer(item) end)
        |> List.to_tuple()
      end)
      |> Enum.map(fn pos -> {pos, "#"} end)
      |> Enum.into(%{})
      |> draw(target)
      |> to_graph(target)
      |> Giraffe.Graph.dijkstra({0, 0}, target)
      |> Kernel.!=(nil)

    case mid_has_path do
      true -> binary_search(lines, target, mid + 1, high)
      false -> binary_search(lines, target, low, mid - 1)
    end
  end

  def path() do
  end

  def to_graph(map, {sx, sy}) do
    Enum.reduce(0..sy, Giraffe.Graph.new(type: :undirected), fn y, g ->
      Enum.reduce(0..sx, g, fn x, gg ->
        if Map.get(map, {x, y}, ".") == "." do
          {x, y}
          |> neighbors()
          |> Enum.reject(fn {x, y} -> x < 0 or x > sx or y < 0 or y > sy end)
          |> Enum.reduce(Giraffe.Graph.add_vertex(gg, {x, y}, "."), fn npos, ggg ->
            if Map.get(map, npos, ".") == "." do
              Giraffe.Graph.add_edge(ggg, {x, y}, npos)
            else
              ggg
            end
          end)
        else
          gg
        end
      end)
    end)
  end

  def draw(list, {sx, sy}) do
    IO.puts("\n")

    Enum.each(0..sy, fn y ->
      Enum.map(0..sx, fn x ->
        Map.get(list, {x, y}, ".")
      end)
      |> Enum.join("")
      |> IO.puts()
    end)

    IO.puts("\n")
    list
  end

  def neighbors({x, y}) do
    [
      {x + 1, y},
      {x, y + 1},
      {x - 1, y},
      {x, y - 1}
    ]
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
