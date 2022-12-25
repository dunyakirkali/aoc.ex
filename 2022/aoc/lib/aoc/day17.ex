defmodule Aoc.Day17 do
  def pieces do
    %{
      0 => [{0, 0}, {1, 0}, {2, 0}, {3, 0}],
      1 => [{1, 0}, {0, 1}, {1, 1}, {2, 1}, {1, 2}],
      2 => [{0, 0}, {1, 0}, {2, 0}, {2, 1}, {2, 2}],
      3 => [{0, 0}, {0, 1}, {0, 2}, {0, 3}],
      4 => [{0, 0}, {1, 0}, {0, 1}, {1, 1}]
    }
  end

  def generate_piece(map, no) do
    {sx, sy} = start_pos(map)
    rem(no, Enum.count(pieces))

    pieces()
    |> Map.get(rem(no, Enum.count(pieces)))
    |> Enum.reduce(map, fn {x, y}, acc ->
      Map.put(acc, {x + sx, y + sy}, "@")
    end)
  end

  def start_pos(map) do
    {2, highest(map)}
  end

  def highest(map) do
    map
    |> Enum.filter(fn {_, v} -> v == "#" end)
    |> Enum.map(fn {{_, y}, _} -> y + 1 end)
    |> Enum.max(fn -> 0 end)
    |> Kernel.+(3)
  end

  def draw(map) do
    size = size(map)

    Enum.each(elem(size, 1)..0, fn y ->
      Enum.map(0..6, fn x ->
        Map.get(map, {x, y}, ".")
      end)
      |> Enum.join("")
      |> IO.puts()
    end)

    IO.puts("\n")
    map
  end

  def tick(map, moves, dir, 0, move) do
    map
    |> generate_piece(0)
    # |> draw
    |> tick(moves, dir, 1, move)
  end

  def tick(map, moves, dir, 2023, move) do
    IO.puts("end game")

    map
    |> Enum.filter(fn {_, v} -> v == "#" end)
    |> Enum.map(fn {{_, y}, v} -> y end)
    |> Enum.max()
    |> Kernel.+(1)
  end

  def tick(map, moves, dir, piece, move) do
    IO.inspect(piece, label: "Piece")

    {map, inc} =
      case move do
        :push ->
          pd = Enum.at(moves, rem(dir, Enum.count(moves)))
          {push_piece(map, pd), 0}

        :fall ->
          fall(map, piece)
      end
      |> then(fn {map, inc} ->
        # draw(map)
        {map, inc}
      end)

    dir =
      if move == :push do
        dir + 1
      else
        dir
      end

    tick(map, moves, dir, piece + inc, change_move(move))
  end

  def change_move(:push), do: :fall
  def change_move(:fall), do: :push

  def fall(map, piece) do
    pp =
      map
      |> Enum.filter(fn {_, v} -> v == "@" end)
      |> Enum.map(fn {{x, y}, _} -> {x, y} end)

    solids =
      map
      |> Enum.filter(fn {_, v} -> v == "#" end)
      |> Enum.map(fn {p, _} -> p end)

    miny =
      pp
      |> Enum.map(fn {_, y} -> y end)
      |> Enum.min()

    ic =
      MapSet.size(
        MapSet.intersection(
          MapSet.new(solids),
          MapSet.new(Enum.map(pp, fn {x, y} -> {x, y - 1} end))
        )
      )

    if miny == 0 or ic > 0 do
      Enum.reduce(pp, map, fn p, acc ->
        Map.put(acc, p, "#")
      end)
      |> generate_piece(piece)
      |> then(fn map ->
        {map, 1}
      end)
    else
      map =
        Enum.reduce(pp, map, fn p, acc ->
          Map.put(acc, p, ".")
        end)

      map =
        Enum.reduce(pp, map, fn {px, py}, acc ->
          Map.put(acc, {px, py - 1}, "@")
        end)

      {map, 0}
    end
  end

  def push_piece(map, direction) do
    {minx, maxx} =
      map
      |> Enum.filter(fn {_, v} -> v == "@" end)
      |> Enum.map(fn {{x, _}, _} -> x end)
      |> Enum.min_max()

    cond do
      minx == 0 and direction == :left -> map
      minx > 0 and direction == :left -> push_left(map)
      maxx == 6 and direction == :right -> map
      maxx < 6 and direction == :right -> push_right(map)
    end
  end

  def push_left(map) do
    solids =
      map
      |> Enum.filter(fn {_, v} -> v == "#" end)
      |> Enum.map(fn {p, _} -> p end)

    pp =
      map
      |> Enum.filter(fn {_, v} -> v == "@" end)
      |> Enum.map(fn {p, _} -> p end)

    ic =
      MapSet.size(
        MapSet.intersection(
          MapSet.new(solids),
          MapSet.new(Enum.map(pp, fn {x, y} -> {x - 1, y} end))
        )
      )

    if ic == 0 do
      map =
        Enum.reduce(pp, map, fn p, acc ->
          Map.put(acc, p, ".")
        end)

      map =
        Enum.reduce(pp, map, fn {px, py}, acc ->
          Map.put(acc, {px - 1, py}, "@")
        end)
    else
      map
    end
  end

  def push_right(map) do
    solids =
      map
      |> Enum.filter(fn {_, v} -> v == "#" end)
      |> Enum.map(fn {p, _} -> p end)

    pp =
      map
      |> Enum.filter(fn {_, v} -> v == "@" end)
      |> Enum.map(fn {p, _} -> p end)

    ic =
      MapSet.size(
        MapSet.intersection(
          MapSet.new(solids),
          MapSet.new(Enum.map(pp, fn {x, y} -> {x + 1, y} end))
        )
      )

    if ic == 0 do
      map =
        Enum.reduce(pp, map, fn p, acc ->
          Map.put(acc, p, ".")
        end)

      map =
        Enum.reduce(pp, map, fn {px, py}, acc ->
          Map.put(acc, {px + 1, py}, "@")
        end)
    else
      map
    end
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

  # @doc """
  #     iex> "priv/day17/example.txt" |> Aoc.Day17.input() |> Aoc.Day17.part1()
  #     3068
  # """
  def part1(moves) do
    tick(%{}, moves, 0, 0, :push)
  end

  # @doc """
  #     iex> moves = "priv/day17/example.txt" |> Aoc.Day17.input() |> Aoc.Day17.part2()
  #     29
  # """
  # def part2(input) do

  # end

  def input(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(fn c ->
      case c do
        "<" -> :left
        ">" -> :right
      end
    end)
  end
end
