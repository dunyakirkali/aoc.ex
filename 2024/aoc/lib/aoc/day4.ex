defmodule Aoc.Day4 do
  @doc """
      iex> "priv/day4/example.txt" |> Aoc.Day4.input() |> Aoc.Day4.part1()
      12

      iex> "priv/day4/example2.txt" |> Aoc.Day4.input() |> Aoc.Day4.part1()
      18
  """
  def part1(list) do
    list
    |> Enum.flat_map(fn {sp, _} ->
      directions()
      |> Enum.map(fn dir ->
        step(list, sp, dir, [])
      end)
    end)
    |> Enum.filter(fn word -> word == "XMAS" end)
    |> Enum.count()
  end

  defp step(list, {x, y}, {dx, dy}, col) do
    if Enum.count(col) == 4 do
      col
      |> Enum.reverse()
      |> Enum.join()
    else
      step(list, {x + dx, y + dy}, {dx, dy}, [Map.get(list, {x, y}, ".") | col])
    end
  end

  defp directions() do
    [
      {1, 0},
      {1, 1},
      {0, 1},
      {-1, 1},
      {-1, 0},
      {-1, -1},
      {0, -1},
      {1, -1}
    ]
  end

  defp x do
    [
      {0, 0},
      {1, -1},
      {1, 1},
      {-1, 1},
      {-1, -1}
    ]
  end

  @doc """
      iex> "priv/day4/example3.txt" |> Aoc.Day4.input() |> Aoc.Day4.part2()
      1

      iex> "priv/day4/example4.txt" |> Aoc.Day4.input() |> Aoc.Day4.part2()
      9
  """
  def part2(list) do
    list
    |> Enum.map(fn {{x, y}, _} ->
      x()
      |> Enum.map(fn {dx, dy} ->
        list
        |> Map.get({x + dx, y + dy}, ".")
      end)
      |> Enum.join()
    end)
    |> Enum.filter(fn word -> Enum.member?(valid_x(), word) end)
    |> Enum.count()
  end

  defp valid_x do
    [
      "ASSMM",
      "AMSSM",
      "ASMMS",
      "AMMSS"
    ]
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {char, x} ->
        {{x, y}, char}
      end)
    end)
    |> Enum.into(%{})
  end
end
