defmodule Aoc.Day1 do
  @goal 2020

  @doc """
      iex> Aoc.Day1.part1([1721, 979, 366, 299, 675, 1456])
      514579
  """
  def part1(list) do
    list
    |> Combination.combine(2)
    |> Enum.find(fn pair ->
      Enum.sum(pair) == @goal
    end)
    |> Enum.reduce(1, fn item, acc ->
      item * acc
    end)
  end

  @doc """
      iex> Aoc.Day1.part2([1721, 979, 366, 299, 675, 1456])
      241861950
  """
  def part2(list) do
    list
    |> Combination.combine(3)
    |> Enum.find(fn tair ->
      Enum.sum(tair) == @goal
    end)
    |> Enum.reduce(1, fn item, acc ->
      item * acc
    end)
  end

  def input() do
    "priv/day1/input.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      String.to_integer(x)
    end)
  end
end
