defmodule Aoc.Day2 do
  @doc """
      iex> Aoc.Day2.part1([[2, 3, 4]])
      58

      iex> Aoc.Day2.part1([[1, 1, 10]])
      43
  """
  def part1(input) do
    input
    |> Enum.map(fn box ->
      area(box) + slack(box)
    end)
    |> Enum.sum
  end

  def area([l, w, h]) do
    2*l*w + 2*w*h + 2*h*l
  end

  def slack(dimensions) do
    dimensions
    |> Enum.sort()
    |> Enum.take(2)
    |> Enum.reduce(fn x, acc -> x * acc end)
  end

  @doc """
      iex> Aoc.Day2.part2([[2, 3, 4]])
      34

      iex> Aoc.Day2.part2([[1, 1, 10]])
      14
  """
  def part2(input) do
    input
    |> Enum.map(fn box ->
      ribbon(box) + bow(box)
    end)
    |> Enum.sum
  end

  def ribbon(dimensions) do
    dimensions
    |> Enum.sort()
    |> Enum.take(2)
    |> Enum.reduce(fn x, acc -> x + acc end)
    |> Kernel.*(2)
  end

  def bow([l, w, h]) do
    l * w * h
  end

  def input() do
    "priv/day2/input.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, "x", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
