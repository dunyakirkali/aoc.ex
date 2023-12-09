defmodule Aoc.Day9 do
  @doc """
      iex> "priv/day9/example.txt" |> Aoc.Day9.input() |> Aoc.Day9.part1()
      114
  """
  def part1(lists) do
    lists
    |> Enum.map(fn list ->
      list
      |> dive([])
      |> surface(0)
    end)
    |> Enum.sum()
  end

  def surface([last], increment), do: increment + List.last(last)

  def surface([h | t], increment) do
    ni = List.last(h)
    surface(t, ni + increment)
  end

  def dive(list, acc) do
    if all_zeros?(list) do
      [list | acc]
    else
      dive(find_step_size(list), [list | acc])
    end
  end

  def find_step_size(list) do
    list
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn pair -> Enum.reverse(pair) end)
    |> Enum.map(fn [nex, pre] -> nex - pre end)
  end

  @doc """
      iex> [0, 0, 0, 0, 0] |> Aoc.Day9.all_zeros?()
      true

      iex> [0, 0, 1, 0, 0] |> Aoc.Day9.all_zeros?()
      false
  """
  def all_zeros?(list) do
    Enum.all?(list, fn x -> x == 0 end)
  end

  @doc """
      iex> "priv/day9/example.txt" |> Aoc.Day9.input() |> Aoc.Day9.part2()
      2
  """
  def part2(lists) do
    lists
    |> Enum.map(fn list ->
      list
      |> dive([])
      |> surface2(0)
    end)
    |> Enum.sum()
  end

  def surface2([last], decrement), do: List.first(last) - decrement

  def surface2([h | t], decrement) do
    nd = List.first(h)
    surface2(t, nd - decrement)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, " ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
