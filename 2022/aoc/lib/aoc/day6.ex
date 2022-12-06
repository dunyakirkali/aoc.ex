defmodule Aoc.Day6 do
  @doc """
      iex> "mjqjpqmgbljsphdztnvjfqwrcgsmlb" |> String.graphemes() |> Aoc.Day6.part1()
      7
  """
  def part1(list) do
    list
    |> Enum.chunk_every(4, 1)
    |> Enum.with_index()
    |> Enum.map(fn {grp, ind} ->
      grp
      |> Enum.uniq()
      |> Enum.count()
      |> then(fn cnt ->
        {grp, cnt, ind + 4}
      end)
    end)
    |> Enum.find(fn {_, cnt, _} ->
      cnt == 4
    end)
    |> elem(2)
  end

  @doc """
      iex> "mjqjpqmgbljsphdztnvjfqwrcgsmlb" |> String.graphemes() |> Aoc.Day6.part2()
      19
  """
  def part2(list) do
    list
    |> Enum.chunk_every(14, 1)
    |> Enum.with_index()
    |> Enum.map(fn {grp, ind} ->
      grp
      |> Enum.uniq()
      |> Enum.count()
      |> then(fn cnt ->
        {grp, cnt, ind + 14}
      end)
    end)
    |> Enum.find(fn {_, cnt, _} ->
      cnt == 14
    end)
    |> elem(2)
  end

  def input() do
    "priv/day6/input.txt"
    |> File.read!()
    |> String.trim()
    |> String.graphemes()
  end
end
