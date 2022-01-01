defmodule Aoc.Day15 do
  @doc """
      iex> input = Aoc.Day15.input("priv/day15/example.txt")
      ...> Aoc.Day15.part1(input)
      40
  """
  def part1(input) do
    input
    |> solve()
  end

  @doc """
      iex> input = Aoc.Day15.input("priv/day15/example.txt")
      ...> Aoc.Day15.part2(input, {10, 10})
      315
  """
  def part2(input, expansion) do
    input
    |> expand(expansion)
    |> solve()
  end

  def solve(map) do
    mx = Map.keys(map) |> Enum.map(fn {x, _} -> x end) |> Enum.max()
    my = Map.keys(map) |> Enum.map(fn {_, y} -> y end) |> Enum.max()
    sp = {0, 0}
    ep = {mx, my}
    distances = %{sp => 0}
    queue = PriorityQueue.new() |> PriorityQueue.push(sp, 0)
    traverse({map, queue, distances, ep})
  end

  def traverse({map, queue, distances, ep}) do
    {{:value, cp}, queue} = PriorityQueue.pop(queue)
    cost = distances[cp]

    if cp == ep do
      cost
    else
      cp
      |> neighbors()
      |> Enum.map(fn np ->
        {np, cost + Map.get(map, np, 999)}
      end)
      |> Enum.reduce({map, queue, distances, ep}, &assess/2)
      |> traverse()
    end
  end

  def assess({np, cost}, {map, queue, distances, ep}) do
    if not Map.has_key?(distances, np) or cost < distances[np] do
      {
        map,
        PriorityQueue.push(queue, np, cost),
        Map.put(distances, np, cost),
        ep
      }
    else
      {map, queue, distances, ep}
    end
  end

  def move({state, max_y}, {{x_from, y_from}, {x_to, y_to}, p}) do
    state
    |> Map.put({x_from, y_from}, nil)
    |> Map.put({x_to, y_to}, p)
    |> then(&{&1, max_y})
  end

  def neighbors({x, y}) do
    [
      {x - 1, y},
      {x, y - 1},
      {x + 1, y},
      {x, y + 1}
    ]
  end

  @doc """
      iex> input = Aoc.Day15.input("priv/day15/example.txt")
      ...> result = Aoc.Day15.input("priv/day15/example_expanded.txt")
      ...> Aoc.Day15.expand(input, {10, 10}) == result
      true
  """
  def expand(map, {dx, dy}) do
    Enum.reduce(0..4, %{}, fn xe, acc ->
      Enum.reduce(0..4, acc, fn ye, acc ->
        Enum.reduce(map, acc, fn {{x, y}, val}, acc ->
          nv = rem(val + xe + ye - 1, 9) + 1
          Map.put(acc, {xe * dx + x, ye * dy + y}, nv)
        end)
      end)
    end)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.graphemes(line)
    end)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, ri}, acc ->
      row
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {col, ci}, acc ->
        Map.put(acc, {ci, ri}, String.to_integer(col))
      end)
    end)
  end
end
