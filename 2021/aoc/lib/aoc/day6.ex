defmodule Aoc.Day6 do
  @doc """
      iex> input = Aoc.Day6.input("priv/day6/example.txt")
      ...> Aoc.Day6.part1(input)
      5934
  """
  def part1(input) do
    input
    |> live(80)
    |> Map.values()
    |> Enum.sum()
  end

  @doc """
      iex> input = Aoc.Day6.input("priv/day6/example.txt")
      ...> Aoc.Day6.part2(input)
      26984457539
  """
  def part2(input) do
    input
    |> live(256)
    |> Map.values()
    |> Enum.sum()
  end

  def live(map, 0), do: map

  def live(map, days) do
    map
    |> Enum.reduce(%{}, fn {k, v}, acc ->
      if k == 0 do
        acc
        |> Map.put(6, Map.get(acc, 6, 0) + v)
        |> Map.put(8, Map.get(acc, 8, 0) + v)
      else
        Map.put(acc, k - 1, Map.get(acc, k - 1, 0) + v)
      end
    end)
    |> live(days - 1)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> List.first()
    |> String.split(",")
    |> Enum.map(&String.to_integer/1)
    |> Enum.reduce(%{}, fn jel, acc ->
      Map.update(acc, jel, 1, fn old ->
        old + 1
      end)
    end)
  end
end
