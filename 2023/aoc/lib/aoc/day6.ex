defmodule Aoc.Day6 do
  @doc """
      iex> "priv/day6/example.txt" |> Aoc.Day6.input() |> Aoc.Day6.part1()
      35
  """
  def part1(input) do
    input
  end

  # @doc """
  #     iex> "priv/day6/example.txt" |> Aoc.Day6.input() |> Aoc.Day6.part2()
  #     46
  # """
  # def part2({seeds, rules}) do
  # end
  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n\n", trim: true)
  end
end
