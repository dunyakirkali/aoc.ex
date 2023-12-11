defmodule Aoc.Day11 do
  use Memoize

  @doc """
      iex> "priv/day11/example.txt" |> Aoc.Day11.input() |> Aoc.Day11.part1()
      374
  """
  def part1(list) do
    list
    |> Map.keys()
    |> Enum.map(fn position ->
      expand(list, position)
    end)
    |> Comb.combinations(2)
    |> Enum.filter(fn [from, to] ->
      from != to
    end)
    |> Enum.reduce([], fn [from, to], acc ->
      [manhattan(from, to) | acc]
    end)
    |> Enum.sum()
  end

  defmemo expand(map, {x, y}, times \\ 2) do
    x_off =
      x..0
      |> Enum.count(fn x ->
        col_empty?(map, x)
      end)
      |> Kernel.*(times - 1)

    y_off =
      y..0
      |> Enum.count(fn y ->
        row_empty?(map, y)
      end)
      |> Kernel.*(times - 1)

    {x + x_off, y + y_off}
  end

  @doc """
      iex> "priv/day11/example.txt" |> Aoc.Day11.input() |> Aoc.Day11.col_empty?(2)
      true

      iex> "priv/day11/example.txt" |> Aoc.Day11.input() |> Aoc.Day11.col_empty?(1)
      false
  """
  def col_empty?(map, col) do
    map
    |> Enum.filter(fn {{x, _}, _} -> x == col end)
    |> Enum.empty?()
  end

  @doc """
      iex> "priv/day11/example.txt" |> Aoc.Day11.input() |> Aoc.Day11.row_empty?(3)
      true

      iex> "priv/day11/example.txt" |> Aoc.Day11.input() |> Aoc.Day11.row_empty?(2)
      false
  """
  def row_empty?(map, row) do
    map
    |> Enum.filter(fn {{_, y}, _} -> y == row end)
    |> Enum.empty?()
  end

  @doc """
      iex> "priv/day11/example.txt" |> Aoc.Day11.input() |> Aoc.Day11.part2(10)
      1030

      iex> "priv/day11/example.txt" |> Aoc.Day11.input() |> Aoc.Day11.part2(100)
      8410
  """
  def part2(list, times) do
    list
    |> Map.keys()
    |> Enum.map(fn position ->
      expand(list, position, times)
    end)
    |> Comb.combinations(2)
    |> Enum.filter(fn [from, to] ->
      from != to
    end)
    |> Enum.reduce([], fn [from, to], acc ->
      [manhattan(from, to) | acc]
    end)
    |> Enum.sum()
  end

  def manhattan({fx, fy}, {tx, ty}) do
    abs(fx - tx) + abs(fy - ty)
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
