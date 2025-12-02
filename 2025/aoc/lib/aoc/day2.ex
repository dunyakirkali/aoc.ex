defmodule Aoc.Day2 do
  @doc """
      iex> "priv/day2/example.txt" |> Aoc.Day2.input() |> Aoc.Day2.part1()
      1227775554
  """
  def part1(list) do
    list
    |> Enum.flat_map(fn range ->
      range
      |> Enum.to_list()
      |> Enum.reduce([], fn n, acc ->
        if is_invalid_1(n) do
          [n | acc]
        else
          acc
        end
      end)
    end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day2/example.txt" |> Aoc.Day2.input() |> Aoc.Day2.part2()
      4174379265
  """
  def part2(list) do
    list
    |> Enum.flat_map(fn range ->
      range
      |> Enum.to_list()
      |> Enum.reduce([], fn n, acc ->
        if is_invalid_2(n) do
          [n | acc]
        else
          acc
        end
      end)
    end)
    |> Enum.sum()
  end

  defp is_invalid_1(n) do
    Regex.match?(~r/^(\d+)\1$/, Integer.to_string(n))
  end

  defp is_invalid_2(n) do
    Regex.match?(~r/^(\d+)\1+$/, Integer.to_string(n))
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.join()
    |> String.split(",", trim: true)
    |> Enum.map(fn range ->
      range
      |> String.split("-", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> then(fn [a, b] ->
        Range.new(a, b)
      end)
    end)
  end
end
