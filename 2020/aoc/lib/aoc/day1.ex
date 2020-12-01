defmodule Aoc.Day1 do
  @goal 2020

  @doc """
      iex> Aoc.Day1.part1([1721, 979, 366, 299, 675, 1456])
      514579
  """
  def part1(list) do
    list
    |> Combination.combine(2)
    |> Enum.reduce_while(0, fn pair, acc ->
      if Enum.sum(pair) == @goal, do: {:halt, pair}, else: {:cont, acc}
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
    |> Enum.reduce_while(0, fn tair, acc ->
      if Enum.sum(tair) == @goal, do: {:halt, tair}, else: {:cont, acc}
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
