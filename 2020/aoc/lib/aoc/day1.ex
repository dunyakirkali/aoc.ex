defmodule Aoc.Day1 do

  def part1() do
    input()
    # |> Enum.map(&(fuel_for(&1)))
    # |> Enum.sum()
  end

  def part2() do
    input()
    # |> Enum.map(&(corrected_fuel_for(&1)))
    # |> Enum.sum()
  end

  defp input() do
    "priv/day1/input.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      String.to_integer(x)
    end)
  end
end
