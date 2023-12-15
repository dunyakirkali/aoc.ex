defmodule Aoc.Day15 do
  @doc """
      iex> "priv/day15/example.txt" |> Aoc.Day15.input() |> Aoc.Day15.part1()
      1320
  """
  def part1(map) do
    map
    |> Enum.map(fn piece -> hash(piece) end)
    |> IO.inspect()
    |> Enum.sum()
  end

  @doc """
      iex> "HASH" |> Aoc.Day15.hash()
      52
  """
  def hash(str), do: do_hash(str, 0)
  def do_hash(<<>>, acc), do: acc

  def do_hash(<<ch::utf8, rest::binary>>, acc) do
    acc = acc + ch
    acc = acc * 17
    acc = rem(acc, 256)

    do_hash(rest, acc)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split(",", trim: true)
    |> IO.inspect()
  end
end
