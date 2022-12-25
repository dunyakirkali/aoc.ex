defmodule Aoc.Day11 do
  @doc """
      iex> "priv/day11/example.txt" |> Aoc.Day11.input() |> Aoc.Day11.part1()
      13140
  """
  def part1(moves) do
    moves
  end

  # @doc """
  #     iex> "priv/day11/example.txt" |> Aoc.Day11.input() |> Aoc.Day11.part2()
  #     :ok
  # """
  # def part2(moves) do
  #   moves
  # end

  def input(filename) do
    filename
    |> File.read!()
  end
end
