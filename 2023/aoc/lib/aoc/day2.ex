defmodule Aoc.Day2 do
  @doc """
      iex> "priv/day2/example.txt" |> Aoc.Day2.input() |> Aoc.Day2.part1()
      8
  """
  def part1(list) do
    bag = [12, 13, 14]

    list
    |> Enum.filter(fn {_, sets} ->
      Enum.all?(sets, fn set ->
        Enum.at(bag, 0) >= Enum.at(set, 0) &&
          Enum.at(bag, 1) >= Enum.at(set, 1) &&
          Enum.at(bag, 2) >= Enum.at(set, 2)
      end)
    end)
    |> Enum.map(fn {id, _} -> id end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day2/example.txt" |> Aoc.Day2.input() |> Aoc.Day2.part2()
      2286
  """
  def part2(list) do
    list
    |> Enum.map(fn {_, sets} ->
      reds = sets |> Enum.map(fn set -> Enum.at(set, 0) end)
      greens = sets |> Enum.map(fn set -> Enum.at(set, 1) end)
      blues = sets |> Enum.map(fn set -> Enum.at(set, 2) end)

      Enum.max(reds) * Enum.max(greens) * Enum.max(blues)
    end)
    |> Enum.sum()
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      res = Regex.named_captures(~r/Game\s+(?<id>\d+):(?<rest>.*)/, line)

      sets =
        res["rest"]
        |> String.split(";")
        |> Enum.map(&String.trim/1)
        |> Enum.map(fn set ->
          red = Regex.named_captures(~r/(?<red>\d+) red/, set) || Map.new()
          green = Regex.named_captures(~r/(?<green>\d+) green/, set) || Map.new()
          blue = Regex.named_captures(~r/(?<blue>\d+) blue/, set) || Map.new()

          [
            String.to_integer(Map.get(red, "red", "0")),
            String.to_integer(Map.get(green, "green", "0")),
            String.to_integer(Map.get(blue, "blue", "0"))
          ]
        end)

      {String.to_integer(res["id"]), sets}
    end)
  end
end
