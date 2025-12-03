defmodule Aoc.Day3 do
  @doc """
      iex> "priv/day3/example.txt" |> Aoc.Day3.input() |> Aoc.Day3.part1()
      357
  """
  def part1(banks) do
    banks
    |> Enum.map(fn bank ->
      joltage(bank, 2)
    end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day3/example.txt" |> Aoc.Day3.input() |> Aoc.Day3.part2()
      3121910778619
  """
  def part2(banks) do
    banks
    |> Enum.map(fn bank ->
      joltage(bank, 12)
    end)
    |> Enum.sum()
  end

  @doc """
      iex> Aoc.Day3.joltage("987654321111111")
      98

      iex> Aoc.Day3.joltage("811111111111119")
      89

      iex> Aoc.Day3.joltage("234234234234278")
      78

      iex> Aoc.Day3.joltage("818181911112111")
      92

      iex> Aoc.Day3.joltage("818181911112111", 12)
      888911112111
  """
  def joltage(nums, count \\ 2) do
    nums
    |> String.graphemes()
    |> Enum.map(&String.to_integer/1)
    |> choose_n(count)
    |> Integer.undigits()
  end

  defp choose_n(digits, n) when n >= length(digits), do: digits

  defp choose_n(digits, n) do
    total = length(digits)
    to_remove = total - n

    digits
    |> Enum.reduce({[], to_remove}, fn d, {stack, r} ->
      {stack2, r2} = pop_while_smaller(stack, d, r)
      {[d | stack2], r2}
    end)
    |> elem(0)
    |> Enum.reverse()
    |> Enum.take(n)
  end

  defp pop_while_smaller(stack, d, r) when r > 0 and stack != [] and hd(stack) < d do
    pop_while_smaller(tl(stack), d, r - 1)
  end

  defp pop_while_smaller(stack, _d, r), do: {stack, r}

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
