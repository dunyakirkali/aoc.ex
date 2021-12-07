defmodule Aoc.Day7 do
  @doc """
      iex> input = Aoc.Day7.input("priv/day7/example.txt")
      ...> Aoc.Day7.part1(input)
      37
  """
  def part1(input) do
    hi = Enum.max(input)
    lo = Enum.min(input)

    lo..hi
    |> Enum.map(fn dest ->
      align_to(input, dest)
    end)
    |> Enum.min()
  end

  @doc """
      iex> input = Aoc.Day7.input("priv/day7/example.txt")
      ...> Aoc.Day7.align_to(input, 2)
      37

      iex> input = Aoc.Day7.input("priv/day7/example.txt")
      ...> Aoc.Day7.align_to(input, 1)
      41

      iex> input = Aoc.Day7.input("priv/day7/example.txt")
      ...> Aoc.Day7.align_to(input, 3)
      39

      iex> input = Aoc.Day7.input("priv/day7/example.txt")
      ...> Aoc.Day7.align_to(input, 10)
      71
  """
  def align_to(input, pos) do
    input
    |> Enum.map(fn x ->
      abs(x - pos)
    end)
    |> Enum.sum()
  end

  @doc """
      iex> input = Aoc.Day7.input("priv/day7/example.txt")
      ...> Aoc.Day7.burn_to(input, 5)
      168

      iex> input = Aoc.Day7.input("priv/day7/example.txt")
      ...> Aoc.Day7.burn_to(input, 2)
      206
  """
  def burn_to(input, pos) do
    input
    |> Enum.map(fn x ->
      len = abs(x - pos)
      div(len * (len + 1), 2)
    end)
    |> Enum.sum()
  end

  @doc """
      iex> input = Aoc.Day7.input("priv/day7/example.txt")
      ...> Aoc.Day7.part2(input)
      168
  """
  def part2(input) do
    hi = Enum.max(input)
    lo = Enum.min(input)

    lo..hi
    |> Enum.map(fn dest ->
      burn_to(input, dest)
    end)
    |> Enum.min()
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> List.first()
    |> String.split(",", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
