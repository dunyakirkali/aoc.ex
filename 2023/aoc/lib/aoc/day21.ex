defmodule Aoc.Day21 do
  use Memoize

  @doc """
      iex> "priv/day21/example.txt" |> Aoc.Day21.input() |> Aoc.Day21.part1(6)
      16
  """
  def part1({start, map}, max) do
    # deque =
    #   1_000_000
    #   |> Deque.new()
    #   |> Deque.appendleft(start)
    #
    # visited = MapSet.new([start])

    # walk(map, deque, 0, visited)
    #
    walk(map, MapSet.new([start]), 0, max)
  end

  def walk(_, reach, s, s), do: Enum.count(reach)

  def walk(map, reach, step, max) do
    {width, height} = size(map)

    reach =
      reach
      |> Enum.flat_map(fn pos ->
        pos
        |> neighbours()
        |> Enum.filter(fn {nx, ny} ->
          nx > -1 and ny > -1 and nx < width and ny < height and
            Map.get(map, {nx, ny}, ".") == "."
        end)
      end)
      |> Enum.into(MapSet.new())

    walk(map, reach, step + 1, max)
  end

  def size(map) do
    map
    |> Map.keys()
    |> Enum.reduce({0, 0}, fn {x, y}, {maxX, maxY} ->
      {max(x, maxX), max(y, maxY)}
    end)
    |> Tuple.to_list()
    |> Enum.map(&(&1 + 1))
    |> List.to_tuple()
  end

  def neighbours({x, y}) do
    [
      {x + 1, y},
      {x, y + 1},
      {x - 1, y},
      {x, y - 1}
    ]
    |> Enum.filter(fn {x, y} ->
      x > -1 and y > -1
    end)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
    end)
    |> Enum.with_index()
    |> Enum.reduce({{0, 0}, Map.new()}, fn {line, y}, acc ->
      line
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {cell, x}, {sp, mp} ->
        case cell do
          "." -> {sp, mp}
          "#" -> {sp, Map.put(mp, {x, y}, cell)}
          "S" -> {{x, y}, mp}
        end
      end)
    end)
  end
end
