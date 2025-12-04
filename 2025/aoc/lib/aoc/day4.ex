defmodule Aoc.Day4 do
  @doc """
      iex> "priv/day4/example.txt" |> Aoc.Day4.input() |> Aoc.Day4.part1()
      13
  """
  def part1(banks) do
    banks
    |> accessible()
    |> Enum.count()
  end

  @doc """
      iex> "priv/day4/example.txt" |> Aoc.Day4.input() |> Aoc.Day4.part2()
      43
  """
  def part2(banks) do
    Stream.interval(1)
    |> Enum.reduce_while({banks, 0}, fn _i, {banks, count} ->
      accessible =
        accessible(banks)
        |> Enum.map(fn {pos, _} -> pos end)
        |> Enum.uniq()

      if accessible == [] do
        {:halt, count}
      else
        new_banks =
          accessible
          |> Enum.reduce(banks, fn pos, acc ->
            Map.put(acc, pos, ".")
          end)

        {:cont, {new_banks, count + length(accessible)}}
      end
    end)
  end

  defp accessible(banks) do
    banks
    |> Enum.filter(fn {_pos, char} -> char == "@" end)
    |> Enum.filter(fn {pos, _char} ->
      pos
      |> neighbours
      |> Enum.count(fn np ->
        Map.get(banks, np, ".") == "@"
      end)
      |> Kernel.<(4)
    end)
  end

  defp neighbours(pos) do
    [{0, -1}, {1, -1}, {1, 0}, {1, 1}, {0, 1}, {-1, 1}, {-1, 0}, {-1, -1}]
    |> Enum.map(fn {dr, dc} -> {elem(pos, 0) + dr, elem(pos, 1) + dc} end)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, row}, acc ->
      line
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {char, col}, acc ->
        Map.put(acc, {row, col}, char)
      end)
    end)
  end
end
