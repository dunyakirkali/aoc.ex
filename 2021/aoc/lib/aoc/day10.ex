defmodule Aoc.Day10 do
  @points %{
    ")" => 3,
    "]" => 57,
    "}" => 1197,
    ">" => 25137
  }
  @points2 %{
    ")" => 1,
    "]" => 2,
    "}" => 3,
    ">" => 4
  }

  @doc """
      iex> input = Aoc.Day10.input("priv/day10/example.txt")
      ...> Aoc.Day10.part1(input)
      26397
  """
  def part1(input) do
    input
    |> Enum.map(&parse/1)
    |> Enum.filter(&is_binary/1)
    |> Enum.map(fn char ->
      Map.get(@points, char)
    end)
    |> Enum.sum()
  end

  def parse(line) do
    Enum.reduce_while(line, [], fn
      "]", ["[" | rest] -> {:cont, rest}
      ">", ["<" | rest] -> {:cont, rest}
      ")", ["(" | rest] -> {:cont, rest}
      "}", ["{" | rest] -> {:cont, rest}
      open, rest when open in ["(", "[", "{", "<"] -> {:cont, [open | rest]}
      mismatch, _ -> {:halt, mismatch}
    end)
  end

  @doc """
      iex> input = Aoc.Day10.input("priv/day10/example.txt")
      ...> Aoc.Day10.part2(input)
      288957
  """
  def part2(input) do
    input
    |> Enum.map(&parse/1)
    |> Enum.reject(&is_binary/1)
    |> Enum.map(fn line ->
      Enum.reduce(line, [], fn
        "[", acc -> ["]" | acc]
        "<", acc -> [">" | acc]
        "(", acc -> [")" | acc]
        "{", acc -> ["}" | acc]
      end)
      |> Enum.reverse()
      |> Enum.reduce(0, fn bracket, sum ->
        sum * 5 + Map.fetch!(@points2, bracket)
      end)
    end)
    |> Enum.sort()
    |> then(fn scores ->
      Enum.at(scores, scores |> length |> div(2))
    end)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, "", trim: true)
    end)
  end
end
