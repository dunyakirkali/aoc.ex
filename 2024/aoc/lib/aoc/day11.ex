defmodule Aoc.Day11 do
  use Memoize

  @doc """
      iex> "priv/day11/example.txt" |> Aoc.Day11.input() |> Aoc.Day11.part1(1)
      [1, 2024, 1, 0, 9, 9, 2021976]

      iex> "priv/day11/example2.txt" |> Aoc.Day11.input() |> Aoc.Day11.part1(1)
      [253000, 1, 7]

      iex> "priv/day11/example2.txt" |> Aoc.Day11.input() |> Aoc.Day11.part1(2)
      [253, 0, 2024, 14168]

      iex> "priv/day11/example2.txt" |> Aoc.Day11.input() |> Aoc.Day11.part1(2)
      [253, 0, 2024, 14168]

      iex> "priv/day11/example2.txt" |> Aoc.Day11.input() |> Aoc.Day11.part1(6)
      [2097446912, 14168, 4048, 2, 0, 2, 4, 40, 48, 2024, 40, 48, 80, 96, 2, 8, 6, 7, 6, 0, 3, 2]
  """
  def part1(list, blink) do
    1..blink
    |> Enum.reduce(list, fn item, acc ->
      Enum.flat_map(acc, fn stone -> change(stone) end)
    end)
  end

  @doc """
      iex> Aoc.Day11.change(0)
      [1]

      iex> Aoc.Day11.change(1000)
      [10, 0]

      iex> Aoc.Day11.change(125)
      [253000]
  """
  defmemo change(stone) do
    cond do
      stone == 0 ->
        [1]

      true ->
        digits = trunc(:math.log10(stone)) + 1

        if rem(digits, 2) == 0 do
          split(Integer.digits(stone))
          |> Enum.map(fn half -> Integer.undigits(half) end)
        else
          [stone * 2024]
        end
    end
  end

  defmemo split(list) do
    len = round(length(list) / 2)

    Enum.split(list, len)
    |> Tuple.to_list()
  end

  def part2(list) do
    list
    |> Enum.map(fn x -> stone_project(x, 75) end)
    |> Enum.sum()
  end

  defmemo(stone_project(_, 0), do: 1)

  defmemo stone_project(x, n) do
    [x]
    |> Enum.flat_map(&change/1)
    |> Enum.map(fn x -> stone_project(x, n - 1) end)
    |> Enum.sum()
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
