defmodule Aoc.Day3 do
  @doc """
      iex> Aoc.Day3.part1(">")
      2

      iex> Aoc.Day3.part1("^>v<")
      4

      iex> Aoc.Day3.part1("^v^v^v^v^v")
      2
  """
  def part1(input) do
    start = {0, 0}
    visited = MapSet.new() |> MapSet.put(start)

    input
    |> String.to_charlist()
    |> move({visited, start})
    |> MapSet.size()
  end

  def move([], {visited, _}), do: visited
  def move([h | t], {visited, {x, y}}) do
    case h do
      ?^ -> visit({visited, {x, y - 1}})
      ?> -> visit({visited, {x + 1, y}})
      ?v -> visit({visited, {x, y + 1}})
      ?< -> visit({visited, {x - 1, y}})
    end
    |> then(fn res ->
      move(t, res)
    end)
  end

  def visit({visited, pos}) do
    {MapSet.put(visited, pos), pos}
  end

  @doc """
      iex> Aoc.Day3.part2("^v")
      3

      iex> Aoc.Day3.part2("^>v<")
      3

      iex> Aoc.Day3.part2("^v^v^v^v^v")
      11
  """
  def part2(input) do
    start = {0, 0}
    visited = MapSet.new() |> MapSet.put(start)

    {santa, robo_santa} =
      input
      |> String.to_charlist()
      |> Enum.with_index()
      |> Enum.split_with(fn {_, index} -> rem(index, 2) == 0 end)
      |> then(fn {santa, robo_santa} ->
        {
          Enum.map(santa, &(elem(&1, 0))),
          Enum.map(robo_santa, &(elem(&1, 0)))
        }
      end)


    santa_visited = move(santa, {visited, start})
    robo_santa_visited = move(robo_santa, {visited, start})

    MapSet.union(santa_visited, robo_santa_visited)
    |> MapSet.size()
  end

  def input() do
    "priv/day3/input.txt"
    |> File.read!()
  end
end
