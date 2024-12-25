defmodule Aoc.Day25 do
  use Memoize

  @doc """
      iex> "priv/day25/example.txt" |> Aoc.Day25.input() |> Aoc.Day25.part1()
      3
  """
  def part1(list) do
    for(
      key <- Enum.filter(list, fn map -> key?(map) end),
      lock <- Enum.filter(list, fn map -> lock?(map) end),
      do: fit?(key, lock)
    )
    |> Enum.count(fn b -> b end)
  end

  def fit?(key, lock) do
    key
    |> to_heights()
    |> Enum.zip(to_heights(lock))
    |> Enum.map(fn {a, b} -> a + b end)
    |> Enum.all?(fn s -> s <= 5 end)
  end

  def to_heights(map) do
    0..width(map)
    |> Enum.map(fn i ->
      Map.filter(map, fn {{x, _}, _} -> x == i end)
      |> Enum.count(fn {_, c} -> c == "#" end)
      |> Kernel.-(1)
    end)
  end

  def lock?(map) do
    check(map, "#", ".")
  end

  def key?(map) do
    check(map, ".", "#")
  end

  def check(map, trc, brc) do
    h = height(map)

    tr =
      map
      |> Enum.filter(fn {{_, y}, _} -> y == 0 end)
      |> Enum.all?(fn {{_, _}, c} -> c == trc end)

    br =
      map
      |> Enum.filter(fn {{_, y}, _} -> y == h end)
      |> Enum.all?(fn {{_, _}, c} -> c == brc end)

    tr && br
  end

  def height(map) do
    map
    |> Map.keys()
    |> Enum.map(fn {_, y} -> y end)
    |> Enum.max()
  end

  def width(map) do
    map
    |> Map.keys()
    |> Enum.map(fn {x, _} -> x end)
    |> Enum.max()
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn group ->
      group
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
    end)
  end
end
