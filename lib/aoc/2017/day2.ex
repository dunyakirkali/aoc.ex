defmodule Aoc.Year2017.Day2 do
  @doc """
      iex> Aoc.Year2017.Day2.part1("priv/2017/day2/example_1.txt")
      18
  """
  def part1(filename) do
    filename
    |> input()
    |> solve1()
  end

  @doc """
      iex> Aoc.Year2017.Day2.part2("priv/2017/day2/example_2.txt")
      9
  """
  def part2(filename) do
    filename
    |> input()
    |> solve2()
  end

  defp solve1(lists) do
    lists
    |> Stream.map(&diff_of_max_min/1)
    |> Enum.sum
  end

  defp solve2(lists) do
    lists
    |> Stream.map(fn line ->
      line
      |> Comb.combinations(2)
      |> Stream.map(fn combination ->
        [lhs, rhs] = Enum.sort(combination)
        {rhs / lhs, rem(rhs, lhs)}
      end)
      |> Stream.filter(fn {_, remainder} ->
        remainder == 0
      end)
      |> Stream.map(fn {division, _} ->
        division
      end)
      |> Enum.to_list()
    end)
    |> Enum.to_list()
    |> List.flatten()
    |> Enum.sum()
    |> Kernel.trunc()
  end

  defp diff_of_max_min(list) do
    Enum.max(list) - Enum.min(list)
  end

  defp input(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split("\n")
    |> Stream.map(fn line ->
      line
      |> String.split("\t")
      |> Stream.map(&String.to_integer/1)
    end)
  end
end
