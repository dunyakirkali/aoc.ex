defmodule Aoc.Day2 do
  @doc """
      iex> "priv/day2/example.txt" |> Aoc.Day2.input() |> Aoc.Day2.part1()
      142
  """
  def part1(list) do
    list
  end

  @doc """
      iex> "priv/day2/example2.txt" |> Aoc.Day2.input() |> Aoc.Day2.part2()
      281
  """
  def part2(list) do

  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
