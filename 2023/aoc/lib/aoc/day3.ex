defmodule Aoc.Day3 do
  @doc """
      iex> "priv/day3/example.txt" |> Aoc.Day3.part1()
      4361
  """
  def part1(filename) do
    map =
      filename
      |> Aoc.Day3.input()

    syms = symbols(map)

    syms
    |> Enum.map(fn {pos, _} -> pos end)
    |> Enum.flat_map(fn pos -> neighbours(pos) end)
    |> Enum.filter(fn pos ->
      Map.get(map, pos, ".")
      |> Integer.parse()
      |> Kernel.!=(:error)
    end)
    |> Enum.map(fn pos ->
      walk_left(map, pos)
    end)
    |> MapSet.new()
    |> Enum.map(fn pos ->
      get_number_at(map, pos, [])
    end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day3/example.txt" |> Aoc.Day3.part2()
      467835
  """
  def part2(filename) do
    map =
      filename
      |> Aoc.Day3.input()

    gears = gears(map)

    gears
    |> Enum.map(fn {pos, _} -> pos end)
    |> Enum.map(fn pos ->
      neighbours(pos)
      |> Enum.filter(fn pos ->
        Map.get(map, pos, ".")
        |> Integer.parse()
        |> Kernel.!=(:error)
      end)
      |> Enum.map(fn pos ->
        walk_left(map, pos)
      end)
      |> MapSet.new()
    end)
    |> Enum.filter(fn lefts -> Enum.count(lefts) == 2 end)
    |> Enum.map(fn lefts ->
      [first, second] =
        lefts
        |> Enum.map(fn left -> get_number_at(map, left, []) end)

      first * second
    end)
    |> Enum.sum()
  end

  def neighbours({x, y}) do
    [
      {x + 1, y},
      {x, y + 1},
      {x - 1, y},
      {x, y - 1},
      {x + 1, y + 1},
      {x - 1, y - 1},
      {x + 1, y - 1},
      {x - 1, y + 1}
    ]
    |> Enum.filter(fn {x, y} ->
      x > -1 and y > -1
    end)
  end

  @doc """
      iex> %{{0, 0} => ".", {1, 0} => "2", {2, 0} => "3"} |> Aoc.Day3.get_number_at({1, 0}, [])
      23
  """
  def get_number_at(map, {x, y} = pos, acc) do
    val = Map.get(map, pos, ".")

    if val |> Integer.parse() |> Kernel.==(:error) do
      acc |> Enum.reverse() |> Integer.undigits()
    else
      get_number_at(map, {x + 1, y}, [String.to_integer(val) | acc])
    end
  end

  @doc """
      iex> %{{0, 0} => ".", {1, 0} => "2", {2, 0} => "3"} |> Aoc.Day3.walk_left({2, 0})
      {1, 0}
  """
  def walk_left(map, {x, y} = pos) do
    if Map.get(map, pos, ".") |> Integer.parse() |> Kernel.==(:error) do
      {x + 1, y}
    else
      walk_left(map, {x - 1, y})
    end
  end

  @doc """
      iex> %{{0, 0} => "*", {0, 1} => "."} |> Aoc.Day3.gears()
      %{{0, 0} => "*"}
  """
  def gears(map) do
    map
    |> Enum.filter(fn {_, v} -> v == "*" end)
    |> Enum.into(%{})
  end

  @doc """
      iex> %{{0, 0} => ".", {0, 1} => "2"} |> Aoc.Day3.symbols()
      %{{0, 0} => "."}
  """
  def symbols(map) do
    map
    |> Enum.filter(fn {_, v} -> Integer.parse(v) == :error end)
    |> Enum.into(%{})
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
        if cell == "." do
          aacc
        else
          Map.put(aacc, {x, y}, cell)
        end
      end)
    end)
  end
end
