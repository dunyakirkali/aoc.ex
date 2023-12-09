defmodule Aoc.Day10 do
  @doc """
      iex> "priv/day10/example.txt" |> Aoc.Day10.input() |> Aoc.Day10.part1()
      142
  """
  def part1(list) do
    list
  end

  # @doc """
  #     iex> "priv/day10/example2.txt" |> Aoc.Day10.input() |> Aoc.Day10.part2()
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
