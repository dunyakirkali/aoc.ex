defmodule Aoc.Day7 do
  @doc """
      iex> "priv/day7/example.txt" |> Aoc.Day7.input() |> Aoc.Day7.part1()
      21
  """
  def part1(l) do
    start =
      Enum.find(l, fn {_pos, char} -> char == "S" end)
      |> elem(0)

    maxx = Enum.map(l, fn {{x, _y}, _char} -> x end) |> Enum.max()
    maxy = Enum.map(l, fn {{_x, y}, _char} -> y end) |> Enum.max()

    {_cache, _visited_splits, count} = tick(l, start, {maxx, maxy}, %{}, MapSet.new())
    count
  end

  @doc """
      iex> "priv/day7/example.txt" |> Aoc.Day7.input() |> Aoc.Day7.part2()
      40
  """
  def part2(l) do
    start =
      Enum.find(l, fn {_pos, char} -> char == "S" end)
      |> elem(0)

    maxx = Enum.map(l, fn {{x, _y}, _char} -> x end) |> Enum.max()
    maxy = Enum.map(l, fn {{_x, y}, _char} -> y end) |> Enum.max()

    {_cache, count} = count_paths(l, start, {maxx, maxy}, %{})
    count
  end

  def count_paths(map, {x, y}, {mx, my}, cache) do
    if Map.has_key?(cache, {x, y}) do
      {cache, Map.get(cache, {x, y})}
    else
      {cache, result} =
        cond do
          my == y ->
            {cache, 1}

          Map.get(map, {x, y}) == "^" ->
            {cache_left, count_left} = count_paths(map, {x - 1, y + 1}, {mx, my}, cache)
            {cache_right, count_right} = count_paths(map, {x + 1, y + 1}, {mx, my}, cache_left)
            {cache_right, count_left + count_right}

          Map.get(map, {x, y}, ".") == "." ->
            count_paths(map, {x, y + 1}, {mx, my}, cache)

          Map.get(map, {x, y}, ".") == "S" ->
            count_paths(map, {x, y + 1}, {mx, my}, cache)
        end

      cache = Map.put(cache, {x, y}, result)
      {cache, result}
    end
  end

  def tick(map, {x, y}, {mx, my}, cache, visited_splits) do
    if MapSet.member?(visited_splits, {x, y}) do
      {cache, visited_splits, 0}
    else
      cond do
        my == y ->
          {cache, visited_splits, 0}

        Map.get(map, {x, y}) == "^" ->
          visited_splits = MapSet.put(visited_splits, {x, y})

          {cache_left, visited_left, count_left} =
            tick(map, {x - 1, y + 1}, {mx, my}, cache, visited_splits)

          {cache_right, visited_right, count_right} =
            tick(map, {x + 1, y + 1}, {mx, my}, cache_left, visited_left)

          {cache_right, visited_right, 1 + count_left + count_right}

        Map.get(map, {x, y}, ".") == "." ->
          tick(map, {x, y + 1}, {mx, my}, cache, visited_splits)

        Map.get(map, {x, y}, ".") == "S" ->
          tick(map, {x, y + 1}, {mx, my}, cache, visited_splits)
      end
    end
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
        Map.put(acc, {col, row}, char)
      end)
    end)
  end
end
