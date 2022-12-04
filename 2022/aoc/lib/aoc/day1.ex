defmodule Aoc.Day1 do
  @doc """
      iex> Aoc.Day1.part1([6000, 4000, 11000, 24000, 10000])
      24000
  """
  def part1(list) do
    list
    |> Enum.max()
  end

  @doc """
      iex> Aoc.Day1.part2([6000, 4000, 11000, 24000, 10000])
      45000
  """
  def part2(list) do
    list
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.sum()
  end

  def input() do
    "priv/day1/input.txt"
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn elf ->
      elf
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum()
    end)
  end
end
