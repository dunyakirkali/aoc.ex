defmodule Aoc.Day1 do
  @goal 2020

  @doc """
      iex> Aoc.Day1.part1([1721, 979, 366, 299, 675, 1456])
      514579
  """
  def part1(list) do
    list
    |> Comb.combinations(2)
    |> Stream.drop_while(fn pair ->
      Enum.sum(pair) != @goal
    end)
    |> Enum.at(0)
    |> Enum.reduce(1, &*/2)
  end

  @doc """
      iex> Aoc.Day1.part2([1721, 979, 366, 299, 675, 1456])
      241861950
  """
  def part2(list) do
    list
    |> Comb.combinations(3)
    |> Stream.drop_while(fn tair ->
      Enum.sum(tair) != @goal
    end)
    |> Enum.at(0)
    |> Enum.reduce(1, &*/2)
  end

  def input() do
    "priv/day1/input.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Stream.map(&String.to_integer/1)
  end
end
