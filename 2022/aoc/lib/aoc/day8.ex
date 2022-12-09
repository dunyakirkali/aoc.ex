defmodule Aoc.Day8 do
  @doc """
      iex> "priv/day8/example.txt" |> Aoc.Day8.input() |> Aoc.Day8.part1()
      21
  """
  def part1(graph) do
    outer(graph) + inner(graph)
  end

  @doc """
      iex> "priv/day8/example.txt" |> Aoc.Day8.input() |> Aoc.Day8.part2()
      8
  """
  def part2(graph) do
    graph
    |> distances()
    |> Enum.max()
  end

  def outer(chart) do
    {width, height} = size(chart)
    height * 2 + (width - 2) * 2
  end

  def inner(chart) do
    {width, height} = size(chart)

    for x <- 1..(width - 2),
        y <- 1..(height - 2),
        Enum.any?(directions(), &visible?(Map.get(chart, {x, y}), chart, {x, y}, &1)),
        reduce: 0 do
      acc ->
        acc + 1
    end
  end

  def visible?(height, chart, {x, y}, {dx, dy}) do
    case Map.get(chart, {x + dx, y + dy}) do
      nil ->
        true

      h when h >= height ->
        false

      _ ->
        visible?(height, chart, {x + dx, y + dy}, {dx, dy})
    end
  end

  def neighbours({x, y}) do
    [{x + 1, y}, {x, y + 1}, {x - 1, y}, {x, y - 1}]
    |> Enum.filter(fn {x, y} ->
      x > -1 and y > -1
    end)
  end

  def directions do
    [{-1, 0}, {1, 0}, {0, -1}, {0, 1}]
  end

  def size(map) do
    {number_of_cols(map), number_of_rows(map)}
  end

  def number_of_rows(map) do
    map
    |> Map.keys()
    |> Enum.map(fn x ->
      elem(x, 1)
    end)
    |> Enum.max()
    |> Kernel.+(1)
  end

  def number_of_cols(map) do
    map
    |> Map.keys()
    |> Enum.map(fn x ->
      elem(x, 0)
    end)
    |> Enum.max()
    |> Kernel.+(1)
  end

  def distances(chart) do
    {width, height} = size(chart)

    for x <- 1..(width - 2), y <- 1..(height - 2) do
      for dir <- directions(), reduce: 1 do
        acc ->
          acc * dis(Map.get(chart, {x, y}), chart, {x, y}, dir)
      end
    end
  end

  def dis(height, chart, {x, y}, {dx, dy}, distance \\ 0) do
    case Map.get(chart, {x + dx, y + dy}) do
      nil ->
        distance

      h when h >= height ->
        distance + 1

      _ ->
        dis(height, chart, {x + dx, y + dy}, {dx, dy}, distance + 1)
    end
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
    end)
    |> Enum.with_index()
    |> Enum.reduce(Map.new(), fn {line, y}, acc ->
      line
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {cell, x}, aacc ->
        Map.put(aacc, {x, y}, String.to_integer(cell))
      end)
    end)
  end
end
