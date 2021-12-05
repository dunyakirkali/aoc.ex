defmodule Aoc.Day5 do
  @doc """
      iex> input = Aoc.Day5.input("priv/day5/example.txt")
      ...> Aoc.Day5.part1(input)
      5
  """
  def part1(input) do
    input
    |> Enum.reduce(%{}, fn line, acc ->
      Enum.reduce(line, acc, fn point, acc ->
        Map.update(acc, point, 1, fn x ->
          x + 1
        end)
      end)
    end)
    |> Enum.count(fn {_, v} ->
      v > 1
    end)
  end

  @doc """
      iex> input = Aoc.Day5.input2("priv/day5/example.txt")
      ...> Aoc.Day5.part2(input)
      12
  """
  def part2(input) do
    input
    |> Enum.reduce(%{}, fn line, acc ->
      Enum.reduce(line, acc, fn point, acc ->
        Map.update(acc, point, 1, fn x ->
          x + 1
        end)
      end)
    end)
    |> Enum.count(fn {_, v} ->
      v > 1
    end)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [[sx, sy], [ex, ey]] =
        String.split(line, " -> ")
        |> Enum.map(fn comp ->
          String.split(comp, ",")
          |> Enum.map(&String.to_integer/1)
        end)

      if sx == ex or sy == ey do
        for x <- sx..ex, y <- sy..ey, do: {x, y}
      else
        nil
      end
    end)
    |> Enum.filter(fn item ->
      item != nil
    end)
  end

  def input2(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, " -> ")
      |> Enum.map(fn comp ->
        String.split(comp, ",")
        |> Enum.map(&String.to_integer/1)
      end)
      |> points([])
    end)
  end

  def points([[sx, sy], [ex, ey]], acc) when sx == ex and sy == ey, do: [{sx, sy} | acc]

  def points([[sx, sy], [ex, ey]], acc) do
    cond do
      sx == ex and sy > ey -> points([[sx, sy - 1], [ex, ey]], [{sx, sy} | acc])
      sx == ex and sy < ey -> points([[sx, sy + 1], [ex, ey]], [{sx, sy} | acc])
      sx > ex and sy == ey -> points([[sx - 1, sy], [ex, ey]], [{sx, sy} | acc])
      sx < ex and sy == ey -> points([[sx + 1, sy], [ex, ey]], [{sx, sy} | acc])
      sx > ex and sy > ey -> points([[sx - 1, sy - 1], [ex, ey]], [{sx, sy} | acc])
      sx > ex and sy < ey -> points([[sx - 1, sy + 1], [ex, ey]], [{sx, sy} | acc])
      sx < ex and sy > ey -> points([[sx + 1, sy - 1], [ex, ey]], [{sx, sy} | acc])
      sx < ex and sy < ey -> points([[sx + 1, sy + 1], [ex, ey]], [{sx, sy} | acc])
    end
  end
end
