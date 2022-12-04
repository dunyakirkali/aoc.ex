defmodule Aoc.Day4 do
  @doc """
      iex> Aoc.Day4.part1([[2..4, 6..8], [2..3, 4..5], [5..7, 7..9], [2..8, 3..7], [6..6, 4..6], [2..6, 4..8]])
      2
  """
  def part1(list) do
    list
    |> Enum.filter(fn [f, s] ->
      fms = MapSet.new(f)
      smp = MapSet.new(s)

      MapSet.subset?(fms, smp) or MapSet.subset?(smp, fms)
    end)
    |> Enum.count()
  end

  @doc """
      iex> Aoc.Day4.part2([[2..4, 6..8], [2..3, 4..5], [5..7, 7..9], [2..8, 3..7], [6..6, 4..6], [2..6, 4..8]])
      4
  """
  def part2(list) do
    list
    |> Enum.filter(fn [f, s] ->
      fms = MapSet.new(f)
      smp = MapSet.new(s)

      MapSet.intersection(fms, smp)
      |> MapSet.size()
      |> Kernel.>(0)
    end)
    |> Enum.count()
  end

  def input() do
    "priv/day4/input.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",", trim: true)
      |> Enum.map(fn part ->
        [s, e] =
          part
          |> String.split("-", trim: true)
          |> Enum.map(&String.to_integer/1)

        Range.new(s, e)
      end)
    end)
  end
end
