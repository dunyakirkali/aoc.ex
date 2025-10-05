defmodule Aoc.Day1 do
  @doc """
      iex> "priv/day1/example.txt" |> Aoc.Day1.input() |> Aoc.Day1.part1()
      11
  """
  def part1(list) do
    list
  end

  # @doc """
  #     iex> "priv/day1/example.txt" |> Aoc.Day1.input() |> Aoc.Day1.part2()
  #     31
  # """
  # def part2(list) do

  # end

  def input(filename) do
    filename
    |> File.read!()
  end
end
