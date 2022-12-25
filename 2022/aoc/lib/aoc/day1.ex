defmodule Aoc.Day1 do
  @doc """
      iex> "priv/day1/example.txt" |> Aoc.Day1.input() |> Aoc.Day1.part1()
      24000
  """
  def part1(list) do
    list
    |> Enum.map(&Enum.sum/1)
    |> Enum.max()
  end

  @doc """
      iex> "priv/day1/example.txt" |> Aoc.Day1.input() |> Aoc.Day1.part2()
      45000
  """
  def part2(list) do
    list
    |> Enum.map(&Enum.sum/1)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.sum()
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn elf ->
      elf
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
