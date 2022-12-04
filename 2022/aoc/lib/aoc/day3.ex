defmodule Aoc.Day3 do
  @doc """
      iex> Aoc.Day3.part1([[22, 36, 18, 23, 16, 49, 20, 23, 36, 7, 49, 18, 8, 3, 19, 32, 39, 39, 6, 32, 32, 8, 32, 16], [10, 17, 34, 44, 40, 17, 44, 10, 17, 26, 10, 33, 30, 38, 33, 38, 18, 19, 32, 39, 6, 32, 52, 45, 18, 38, 18, 32, 52, 19, 45, 38], [42, 13, 13, 4, 26, 17, 42, 18, 48, 22, 42, 23, 23, 46, 49, 28, 23, 7], [23, 39, 17, 22, 38, 39, 52, 34, 8, 34, 39, 22, 23, 38, 34, 10, 2, 22, 3, 10, 14, 14, 45, 28, 14, 22, 46, 43, 32, 14], [20, 20, 7, 36, 20, 44, 33, 36, 43, 3, 20, 46, 52, 20, 52, 46], [29, 18, 52, 19, 36, 19, 42, 42, 52, 19, 33, 26, 23, 23, 19, 38, 23, 38, 13, 16, 23, 39, 30, 23]])
      157
  """
  def part1(list) do
    list
    |> Enum.map(fn list ->
      half = div(Enum.count(list), 2)

      {
        Enum.slice(list, 0..(half - 1)) |> MapSet.new(),
        Enum.slice(list, half..-1) |> MapSet.new()
      }
    end)
    |> Enum.flat_map(fn {l, r} ->
      MapSet.intersection(l, r)
      |> MapSet.to_list()
    end)
    |> Enum.sum()
  end

  @doc """
      iex> Aoc.Day3.part2([[22, 36, 18, 23, 16, 49, 20, 23, 36, 7, 49, 18, 8, 3, 19, 32, 39, 39, 6, 32, 32, 8, 32, 16], [10, 17, 34, 44, 40, 17, 44, 10, 17, 26, 10, 33, 30, 38, 33, 38, 18, 19, 32, 39, 6, 32, 52, 45, 18, 38, 18, 32, 52, 19, 45, 38], [42, 13, 13, 4, 26, 17, 42, 18, 48, 22, 42, 23, 23, 46, 49, 28, 23, 7], [23, 39, 17, 22, 38, 39, 52, 34, 8, 34, 39, 22, 23, 38, 34, 10, 2, 22, 3, 10, 14, 14, 45, 28, 14, 22, 46, 43, 32, 14], [20, 20, 7, 36, 20, 44, 33, 36, 43, 3, 20, 46, 52, 20, 52, 46], [29, 18, 52, 19, 36, 19, 42, 42, 52, 19, 33, 26, 23, 23, 19, 38, 23, 38, 13, 16, 23, 39, 30, 23]])
      70
  """
  def part2(list) do
    list
    |> Stream.map(fn list ->
      list
      |> MapSet.new()
    end)
    |> Stream.chunk_every(3)
    |> Stream.map(fn chunk ->
      chunk
      |> Enum.drop(1)
      |> Enum.reduce(hd(chunk), fn sack, acc ->
        MapSet.intersection(acc, sack)
      end)
    end)
    |> Enum.to_list()
    |> Enum.sort()
    |> Enum.flat_map(fn set ->
      set
      |> Enum.to_list()
    end)
    |> Enum.sum()
  end

  def input() do
    "priv/day3/input.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.to_charlist()
      |> Enum.map(fn c ->
        case c do
          x when x in 97..122 -> x - 96
          x -> x - 38
        end
      end)
    end)
  end
end
