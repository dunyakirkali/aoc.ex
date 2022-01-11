defmodule Aoc.Day1 do
  @doc """
      iex> Aoc.Day1.part1("(())")
      0

      iex> Aoc.Day1.part1("()()")
      0

      iex> Aoc.Day1.part1("(((")
      3

      iex> Aoc.Day1.part1("(()(()(")
      3

      iex> Aoc.Day1.part1("))(((((")
      3

      iex> Aoc.Day1.part1("())")
      -1

      iex> Aoc.Day1.part1("))(")
      -1

      iex> Aoc.Day1.part1(")))")
      -3

      iex> Aoc.Day1.part1(")())())")
      -3
  """
  def part1(string) do
    string
    |> String.graphemes()
    |> Enum.map(&map/1)
    |> Enum.sum()
  end

  def map("("), do: 1
  def map(")"), do: -1

  @doc """
      iex> Aoc.Day1.part2(")")
      1

      iex> Aoc.Day1.part2("()())")
      5
  """
  def part2(string) do
    string
    |> String.graphemes()
    |> climb(0, 0)
  end

  def climb(_, pos, -1), do: pos
  def climb([h | t], pos, floor), do: climb(t, pos + 1, floor + map(h))

  def input() do
    "priv/day1/input.txt"
    |> File.read!()
    # |> String.split("\n", trim: true)
    # |> Stream.map(&String.to_integer/1)
  end
end
