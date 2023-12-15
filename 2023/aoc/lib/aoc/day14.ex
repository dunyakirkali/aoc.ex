defmodule Aoc.Day14 do
  @doc """
      iex> "priv/day14/example.txt" |> Aoc.Day14.input() |> Aoc.Day14.part2()
      64
  """
  def part2(map) do
    1..1_000
    |> Enum.reduce(map, fn cycle, mmap ->
      IO.puts(cycle)

      [:north, :west, :south, :east]
      |> Enum.reduce(mmap, fn direction, mmmap ->
        tilt(mmmap, direction)
      end)
    end)
    |> score()
  end

  @doc """
      iex> "priv/day14/example.txt" |> Aoc.Day14.input() |> Aoc.Day14.part1()
      136
  """
  def part1(map) do
    map
    |> tilt(:north)
    |> score()
  end

  def tilt(map, :east) do
    {_, height} = size(map)

    0..(height - 1)
    |> Enum.flat_map(fn cn ->
      row(map, cn)
      |> Enum.reverse()
      |> Enum.join("")
      |> slide()
      |> String.split("", trim: true)
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.map(fn {v, index} ->
        {{index, cn}, v}
      end)
    end)
    |> Enum.into(%{})
  end

  def tilt(map, :west) do
    {_, height} = size(map)

    0..(height - 1)
    |> Enum.flat_map(fn cn ->
      row(map, cn)
      |> Enum.join("")
      |> slide()
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {v, index} ->
        {{index, cn}, v}
      end)
    end)
    |> Enum.into(%{})
  end

  def tilt(map, :south) do
    {width, _} = size(map)

    0..(width - 1)
    |> Enum.flat_map(fn cn ->
      col(map, cn)
      |> Enum.reverse()
      |> Enum.join("")
      |> slide()
      |> String.split("", trim: true)
      |> Enum.reverse()
      |> Enum.with_index()
      |> Enum.map(fn {v, index} ->
        {{cn, index}, v}
      end)
    end)
    |> Enum.into(%{})
  end

  def tilt(map, :north) do
    {width, _} = size(map)

    0..(width - 1)
    |> Enum.flat_map(fn cn ->
      col(map, cn)
      |> Enum.join("")
      |> slide()
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {v, index} ->
        {{cn, index}, v}
      end)
    end)
    |> Enum.into(%{})
  end

  def row(map, r) do
    Enum.filter(map, fn {{_, y}, _} ->
      y == r
    end)
    |> Enum.sort_by(fn {{x, _}, _} -> x end)
    |> Enum.map(fn {_, v} -> v end)
  end

  def score(map) do
    {_, height} = size(map)

    map
    |> Enum.filter(fn {_, v} ->
      v == "O"
    end)
    |> Enum.map(fn {{_, y}, _} ->
      height - y
    end)
    |> Enum.sum()
  end

  @doc """
      iex> "OO.O.O..#" |> Aoc.Day14.slide()
      "OOOO....#"

      iex> ".O...#O..O" |> Aoc.Day14.slide()
      "O....#OO.."

      iex> "#O...#O..O" |> Aoc.Day14.slide()
      "#O...#OO.."

      iex> "#.O..#O.#O" |> Aoc.Day14.slide()
      "#O...#O.#O"

      iex> "#.O..#O.O#" |> Aoc.Day14.slide()
      "#O...#OO.#"

      iex> "#.O..#O.O#" |> Aoc.Day14.slide()
      "#O...#OO.#"

      iex> "#.O.#....#.......O" |> Aoc.Day14.slide()
      "#O..#....#O......."
  """
  def slide(col) do
    col
    |> String.split("#")
    |> Enum.map(fn part ->
      part
      |> String.graphemes()
      |> Enum.sort(:desc)
      |> Enum.join()
    end)
    |> Enum.join("#")
  end

  def col(map, c) do
    Enum.filter(map, fn {{x, _}, _} ->
      x == c
    end)
    |> Enum.sort_by(fn {{_, y}, _} -> y end)
    |> Enum.map(fn {_, v} -> v end)
  end

  def draw(map) do
    IO.puts("\n")

    {minx, maxx} =
      map
      |> Map.keys()
      |> Enum.map(&elem(&1, 0))
      |> Enum.min_max()

    {miny, maxy} =
      map
      |> Map.keys()
      |> Enum.map(&elem(&1, 1))
      |> Enum.min_max()

    Enum.each(miny..maxy, fn y ->
      Enum.map(minx..maxx, fn x ->
        Map.get(map, {x, y}, ".")
      end)
      |> Enum.join("")
      |> IO.puts()
    end)

    IO.puts("\n")
    map
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

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
    end)
    |> Enum.with_index()
    |> Enum.reduce(Map.new(), fn {line, y}, acc ->
      line
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {cell, x}, aacc ->
        Map.put(aacc, {x, y}, cell)
      end)
    end)
  end
end
