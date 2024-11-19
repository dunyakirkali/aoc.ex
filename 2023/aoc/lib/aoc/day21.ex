defmodule Aoc.Day21 do
  use Memoize

  @doc """
      iex> "priv/day21/example.txt" |> Aoc.Day21.input() |> Aoc.Day21.part1(6)
      16
  """
  def part1({start, map, {w, h}}, max) do
    walk(map, MapSet.new([start]), 0, max, {w, h})
  end

  @doc """
      iex> "priv/day21/example.txt" |> Aoc.Day21.input() |> Aoc.Day21.part2(6)
      16

      iex> "priv/day21/example.txt" |> Aoc.Day21.input() |> Aoc.Day21.part2(10)
      50

      # iex> "priv/day21/example.txt" |> Aoc.Day21.input() |> Aoc.Day21.part2(50)
      # 1594
      #
      # iex> "priv/day21/example.txt" |> Aoc.Day21.input() |> Aoc.Day21.part2(100)
      # 6536
      #
      # iex> "priv/day21/example.txt" |> Aoc.Day21.input() |> Aoc.Day21.part2(500)
      # 167004
      #
      # iex> "priv/day21/example.txt" |> Aoc.Day21.input() |> Aoc.Day21.part2(1000)
      # 668697
      #
      # iex> "priv/day21/example.txt" |> Aoc.Day21.input() |> Aoc.Day21.part2(5000)
      # 16733044
  """
  def part2({{sx, sy}, map, {w, h}}, max) do
    remainder = rem(max, w)

    v1 = walk2(map, MapSet.new([{sx + 500 * w, sy + 500 * h}]), 0, remainder, {w, h})
    v2 = walk2(map, MapSet.new([{sx + 500 * w, sy + 500 * h}]), 0, remainder + w, {w, h})
    v3 = walk2(map, MapSet.new([{sx + 500 * w, sy + 500 * h}]), 0, remainder + 2 * w, {w, h})

    a = div(v1 - 2 * v2 + v3, 2)
    b = div(-3 * v1 + 4 * v2 - v3, 2)
    c = v1
    n = div(max, w)

    a * n * n + b * n + c
  end

  def walk2(_, reach, s, s, _), do: Enum.count(reach)

  def walk2(map, reach, step, max, {width, height}) do
    reach =
      reach
      |> Enum.flat_map(fn pos ->
        pos
        |> neighbours()
        |> Enum.filter(fn {nx, ny} ->
          {nx, ny} =
            {rem(nx, width), rem(ny, height)}

          # |> IO.inspect()

          Map.get(map, {nx, ny}, ".") == "."
        end)
      end)
      |> Enum.into(MapSet.new())

    walk2(map, reach, step + 1, max, {width, height})
  end

  def walk(_, reach, s, s, _), do: Enum.count(reach)

  def walk(map, reach, step, max, {w, h}) do
    reach =
      reach
      |> Enum.flat_map(fn pos ->
        pos
        |> neighbours()
        |> Enum.filter(fn {nx, ny} ->
          nx > -1 and ny > -1 and nx < w and ny < h and
            Map.get(map, {nx, ny}, ".") == "."
        end)
      end)
      |> Enum.into(MapSet.new())

    walk(map, reach, step + 1, max, {w, h})
  end

  def neighbours({x, y}) do
    [
      {x + 1, y},
      {x, y + 1},
      {x - 1, y},
      {x, y - 1}
    ]
  end

  def input(filename) do
    pieces =
      filename
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split("", trim: true)
      end)

    height = Enum.count(pieces)
    width = Enum.count(Enum.at(pieces, 0))

    {start, map} =
      pieces
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

    {start, map, {width, height}}
  end
end
