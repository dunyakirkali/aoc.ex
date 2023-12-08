defmodule Aoc.Day9 do
  @doc """
      iex> "priv/day9/example.txt" |> Aoc.Day9.input() |> Aoc.Day9.part1()
      142
  """
  def part1(list) do
    list
  end

  # @doc """
  #     iex> "priv/day9/example2.txt" |> Aoc.Day9.input() |> Aoc.Day9.part2()
  #     281
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
