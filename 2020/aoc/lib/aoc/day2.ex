defmodule Aoc.Day2 do
  @doc """
      iex> inp = Aoc.Day2.input("priv/day2/example.txt")
      ...> Aoc.Day2.part1(inp)
      2
  """
  def part1(inp) do
    inp
    |> Enum.map(fn line ->
      valid(line)
    end)
    |> Enum.count(fn res ->
      res == true
    end)
  end

  @doc """
      iex> inp = Aoc.Day2.input("priv/day2/example.txt")
      ...> Aoc.Day2.part2(inp)
      1
  """
  def part2(inp) do
    inp
    |> Enum.map(fn line ->
      valid2(line)
    end)
    |> Enum.count(fn res ->
      res == true
    end)
  end

  def valid2(data) do
    min = String.to_integer(data["min"])
    max = String.to_integer(data["max"])
    graphemes = String.graphemes(data["password"])

    poss = [Enum.at(graphemes, min - 1), Enum.at(graphemes, max - 1)]

    Enum.count(poss, fn char ->
      char == data["letter"]
    end) == 1
  end

  def valid(data) do
    min = String.to_integer(data["min"])
    max = String.to_integer(data["max"])

    count =
      data["password"]
      |> String.graphemes()
      |> Enum.count(fn char ->
        char == data["letter"]
      end)

    count >= min && count <= max
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      Regex.named_captures(~r/(?<min>\d+)-(?<max>\d+) (?<letter>.): (?<password>.*)/, line)
    end)
  end
end
