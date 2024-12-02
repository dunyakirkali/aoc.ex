defmodule Aoc.Day3 do
  @doc """
      iex> "priv/day3/example.txt" |> Aoc.Day3.input() |> Aoc.Day3.part1()
      2
  """
  def part1(list) do
    list
  end

  # @doc """
  #     iex> "priv/day3/example.txt" |> Aoc.Day3.input() |> Aoc.Day3.part2()
  #     4
  # """
  # def part2(list) do
  #   list
  # end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
