defmodule Aoc.Day1 do
  @doc """
      iex> "priv/day1/example.txt" |> Aoc.Day1.input() |> Aoc.Day1.part1()
      3
  """
  def part1(list) do
    list
    |> Enum.reduce({50, 0}, fn {dir, amt}, {acc, cnt} ->
      na = turn(dir, acc, amt)
      if(na == 0, do: {na, cnt + 1}, else: {na, cnt})
    end)
    |> elem(1)
  end

  defp turn(:right, current, amount), do: rem(current + amount, 100)
  defp turn(:left, current, amount), do: rem(rem(current - amount, 100) + 100, 100)

  @doc """
      iex> Aoc.Day1.part2([right: 1000])
      10

      iex> Aoc.Day1.part2([left: 1000])
      10

      iex> "priv/day1/example.txt" |> Aoc.Day1.input() |> Aoc.Day1.part2()
      6
  """
  def part2(list) do
    list
    |> Enum.reduce({50, 0}, fn {dir, amt}, {acc, cnt} ->
      passes = passes_through_zero(acc, dir, amt)

      na = turn(dir, acc, amt)
      {na, cnt + passes}
    end)
    |> elem(1)
  end

  defp passes_through_zero(p, :right, amt), do: div(p + amt, 100)
  defp passes_through_zero(0, :left, amt), do: div(amt, 100)
  defp passes_through_zero(p, :left, amt) when amt < p, do: 0
  defp passes_through_zero(p, :left, amt), do: 1 + div(amt - p, 100)

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      [dir | rest] = String.graphemes(x)

      case dir do
        "R" -> {:right, String.to_integer(Enum.join(rest))}
        "L" -> {:left, String.to_integer(Enum.join(rest))}
      end
    end)
  end
end
