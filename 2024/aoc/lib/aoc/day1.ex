defmodule Aoc.Day1 do
  @doc """
      iex> "priv/day1/example.txt" |> Aoc.Day1.input() |> Aoc.Day1.part1()
      142
  """
  def part1(list) do
    list
    |> Enum.map(&String.to_integer/1)
  end

  # @doc """
  #     iex> "priv/day1/example2.txt" |> Aoc.Day1.input() |> Aoc.Day1.part2()
  #     281
  # """
  # def part2(list) do
  # end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
