defmodule Aoc.Day9 do
  use Agent

  def start do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc """
      iex> input = Aoc.Day9.input("priv/day9/example.txt")
      ...> Aoc.Day9.part1(input)
      15
  """
  def part1(input) do
    input
    |> find_lowest()
    |> Enum.map(fn post ->
      Map.get(input, post) + 1
    end)
    |> Enum.sum()
  end

  def find_lowest(input) do
    input
    |> Enum.map(fn {point, _} ->
      ns = neighbors(point)
      {point, Enum.map(ns, fn pos -> Map.get(input, pos, 9) end)}
    end)
    |> Enum.filter(fn {point, neighbors} ->
      Map.get(input, point) < Enum.min(neighbors)
    end)
    |> Enum.map(fn {x, _} -> x end)
  end

  @doc """
      iex> Aoc.Day9.neighbors({1, 1}, 1)
      [{0, 1}, {1, 2}, {1, 0}, {2, 1}]
  """
  def neighbors(point, size \\ 1) do
    left = {elem(point, 0) - size, elem(point, 1)}
    right = {elem(point, 0) + size, elem(point, 1)}
    up = {elem(point, 0), elem(point, 1) - size}
    down = {elem(point, 0), elem(point, 1) + size}

    [left, down, up, right]
  end

  @doc """
      iex> input = Aoc.Day9.input("priv/day9/example.txt")
      ...> Aoc.Day9.part2(input)
      1134
  """
  def part2(input) do
    start()

    input
    |> find_lowest()
    |> Enum.map(fn point ->
      basins(input, point, point)

      Agent.get(__MODULE__, &Map.get(&1, point, []))
      |> Enum.count()
    end)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.reduce(1, &(&1 * &2))
  end

  def basins(input, root, point) do
    points = Agent.get(__MODULE__, &Map.get(&1, root, []))

    if Map.get(input, point, 9) != 9 do
      if !Enum.member?(points, point) do
        Agent.update(__MODULE__, &Map.put(&1, root, [point | points]))

        Enum.map(neighbors(point), fn x ->
          basins(input, root, x)
        end)
      end
    end
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {rows, y}, acc ->
      rows
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {item, x}, acc ->
        Map.put(acc, {x, y}, String.to_integer(item))
      end)
    end)
  end
end
