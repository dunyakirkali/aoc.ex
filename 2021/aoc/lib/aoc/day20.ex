defmodule Aoc.Day20 do
  @doc """
      iex> input = Aoc.Day20.input("priv/day20/example.txt")
      ...> Aoc.Day20.part1(input)
      35
  """
  def part1(input) do
    input
    |> step(2)
    |> count_lit()
  end

  def count_lit(map) do
    map
    |> Enum.count(fn {_, val} ->
      val == "#"
    end)
  end

  @doc """
      iex> input = Aoc.Day20.input("priv/day20/example.txt")
      ...> Aoc.Day20.part2(input)
      3351
  """
  def part2(input) do
    input
    |> step(50)
    |> count_lit()
  end

  def step({_, input}, 0), do: input

  def step({algorithm, input}, count) do
    {minx, maxx} =
      input
      |> Map.keys()
      |> Enum.map(&elem(&1, 0))
      |> Enum.min_max()

    {miny, maxy} =
      input
      |> Map.keys()
      |> Enum.map(&elem(&1, 1))
      |> Enum.min_max()

    gro = 3

    for(y <- (miny - gro)..(maxy + gro), x <- (minx - gro)..(maxx + gro), do: {x, y})
    |> Enum.map(fn coords ->
      sub_to_bin(coords, {algorithm, input})
    end)
    |> Enum.into(%{})
    |> then(fn map ->
      step({algorithm, map}, count - 1)
    end)
  end

  def print(map) do
    IO.puts("")

    {minx, maxx} = Map.keys(map) |> Enum.map(fn {x, _} -> x end) |> Enum.min_max()
    {miny, maxy} = Map.keys(map) |> Enum.map(fn {_, y} -> y end) |> Enum.min_max()

    Enum.map(minx..maxx, fn row ->
      Enum.map(miny..maxy, fn col ->
        pos = {col, row}
        value = Map.get(map, pos, ".")
        to_string(value)
      end)
      |> Enum.intersperse("")
    end)
    |> Enum.join("\n")
    |> IO.puts()

    map
  end

  @doc """
      # iex> input = Aoc.Day20.input("priv/day20/example.txt")
      # ...> Aoc.Day20.sub_to_bin({2,2}, input)
      # {{2, 2}, "#"}

      # iex> input = Aoc.Day20.input("priv/day20/example.txt")
      # ...> Aoc.Day20.sub_to_bin({0,0}, input)
      # {{0, 0}, "."}

      iex> input = Aoc.Day20.input("priv/day20/example.txt")
      ...> Aoc.Day20.sub_to_bin({1,0}, input)
      {{1, 0}, "."}

      iex> input = Aoc.Day20.input("priv/day20/example.txt")
      ...> Aoc.Day20.sub_to_bin({2,0}, input)
      {{2, 0}, "#"}

      iex> input = Aoc.Day20.input("priv/day20/example.txt")
      ...> Aoc.Day20.sub_to_bin({3,0}, input)
      {{3, 0}, "."}

      iex> input = Aoc.Day20.input("priv/day20/example.txt")
      ...> Aoc.Day20.sub_to_bin({4,0}, input)
      {{4, 0}, "#"}
  """
  def sub_to_bin(point, {algorithm, input}) do
    point
    |> neighbors()
    |> Enum.map(fn coord ->
      Map.get(input, coord, ".")
    end)
    |> Enum.map(fn cell ->
      case cell do
        "." -> 0
        "#" -> 1
      end
    end)
    |> Enum.join()
    |> String.to_integer(2)
    |> then(fn address ->
      {point, Enum.at(algorithm, address)}
    end)
  end

  @doc """
      iex> Aoc.Day20.neighbors({2,2})
      [{1, 1}, {2, 1}, {3, 1}, {1, 2}, {2, 2}, {3, 2}, {1, 3}, {2, 3}, {3, 3}]
  """
  def neighbors({x, y}) do
    [
      {x - 1, y - 1},
      {x, y - 1},
      {x + 1, y - 1},
      {x - 1, y},
      {x, y},
      {x + 1, y},
      {x - 1, y + 1},
      {x, y + 1},
      {x + 1, y + 1}
    ]
  end

  def input(filename) do
    [algorithm, input] =
      filename
      |> File.read!()
      |> String.split("\n\n", trim: true)

    algorithm =
      algorithm
      |> String.replace("\n", "")
      |> String.graphemes()

    input =
      input
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {row, y}, acc ->
        row
        |> String.graphemes()
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {char, x}, acc ->
          Map.put(acc, {x, y}, char)
        end)
      end)

    {algorithm, input}
  end
end
