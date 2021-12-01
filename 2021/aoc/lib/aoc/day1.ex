defmodule Aoc.Day1 do
  @doc """
      iex> Aoc.Day1.part1([199, 200, 208,210,200,207,240,269,260,263])
      7
  """
  def part1(list) do
    list
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [p, n] ->
      if n > p do
        :inc
      else
        :dec
      end
    end)
    |> Enum.count(fn x ->
      x == :inc
    end)
  end

  @doc """
      iex> Aoc.Day1.part2([199, 200, 208,210,200,207,240,269,260,263])
      5
  """
  def part2(list) do
    list
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.map(fn l ->
      Enum.sum(l)
    end)
    |> part1()
  end

  def input() do
    "priv/day1/input.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Stream.map(&String.to_integer/1)
  end
end
