defmodule Aoc.Day6 do
  @doc """
      iex> inp = Aoc.Day6.input("priv/day6/example.txt")
      ...> Aoc.Day6.part1(inp)
      6

      iex> inp = Aoc.Day6.input("priv/day6/example2.txt")
      ...> Aoc.Day6.part1(inp)
      11
  """
  def part1(inp) do
    inp
    |> Enum.map(fn row ->
      row
      |> String.replace("\n", "")
      |> String.graphemes()
      |> Enum.uniq()
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  @doc """
      iex> inp = Aoc.Day6.input("priv/day6/example.txt")
      ...> Aoc.Day6.part2(inp)
      3

      iex> inp = Aoc.Day6.input("priv/day6/example2.txt")
      ...> Aoc.Day6.part2(inp)
      6
  """
  def part2(inp) do
    inp
    |> Enum.map(fn row ->
      row
      |> String.split("\n", trim: true)
      |> Enum.map(fn per ->
        per
        |> String.graphemes()
        |> MapSet.new()
      end)
      |> Enum.reduce(0, fn pair, acc ->
        if acc == 0 do
          pair
        else
          MapSet.intersection(pair, acc)
        end
      end)
      |> MapSet.size()
    end)
    |> Enum.sum()
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n\n", trim: true)
  end
end
