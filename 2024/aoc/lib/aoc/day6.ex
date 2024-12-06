defmodule Aoc.Day6 do
  @doc """
      iex> "priv/day6/example.txt" |> Aoc.Day6.input() |> Aoc.Day6.part1()
      41
  """
  def part1(list) do
    {m, c} = list

    solve(m, c)
    |> Enum.count()
  end

  @doc """
      iex> "priv/day6/example.txt" |> Aoc.Day6.input() |> elem(0) |> Aoc.Day6.size()
      {9, 9}

      iex> "priv/day6/input.txt" |> Aoc.Day6.input() |> elem(0) |> Aoc.Day6.size()
      {129, 129}
  """
  def size(map) do
    {max_x, max_y} =
      map
      |> Enum.reduce({0, 0}, fn {{x, y}, _}, {max_x, max_y} ->
        {max(x, max_x), max(y, max_y)}
      end)

    {max_x, max_y}
  end

  defp solve(m, c) do
    {sx, sy} = size(m)
    Stream.iterate(1, &(&1 + 1))
    |> Enum.reduce_while({m, c, "^", [{c, "^"}]}, fn _, {map, cp, dir, visited} ->
      {cx, cy} = cp
      np = dir(dir, {cx, cy})
      {nx, ny} = np

      if nx < 0 or ny < 0 or nx > sx or ny > sy do
        {:halt, visited}
      else
        case Map.get(map, np, ".") do
          "#" -> {:cont, {map, {cx, cy}, turn(dir), visited}}
          "." -> {:cont, {map, np, dir, [{np, dir} | visited]}}
        end
      end
    end)
    |> Enum.map(fn {k, _} -> k end)
    |> Enum.uniq()
  end

  def turn("^"), do: ">"
  def turn(">"), do: "v"
  def turn("v"), do: "<"
  def turn("<"), do: "^"

  def dir("^", {x, y}), do: {x, y - 1}
  def dir("v", {x, y}), do: {x, y + 1}
  def dir(">", {x, y}), do: {x + 1, y}
  def dir("<", {x, y}), do: {x - 1, y}

  @doc """
      iex> "priv/day6/example.txt" |> Aoc.Day6.input() |> Aoc.Day6.part2()
      6
  """
  def part2(list) do
    {m, c} = list
    {sx, sy} = size(m)
    solve(m, c)
    |> Enum.with_index()
    |> Enum.map(fn {obstacle, i} ->
      Stream.iterate(1, &(&1 + 1))
      |> Enum.reduce_while({Map.put(m, obstacle, "#"), c, "^", MapSet.new([{c, "^"}])}, fn _, {map, cp, dir, visited} ->
        {cx, cy} = cp
        np = dir(dir, {cx, cy})
        {nx, ny} = np

        if nx < 0 or ny < 0 or nx > sx or ny > sy do
          {:halt, 0}
        else
          case Map.get(map, np, ".") do
            "#" -> {:cont, {map, {cx, cy}, turn(dir), visited}}
            "." ->
              if MapSet.member?(visited, {np, dir}) do
                {:halt, 1}
              else
                {:cont, {map, np, dir, MapSet.put(visited, {np, dir})}}
              end
          end
        end
      end)
    end)
    |> Enum.sum
  end

  def input(filename) do
    map =
      filename
      |> File.read!()
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

    {pp, _} =
      Enum.find(map, fn {_, v} -> v != "." and v != "#" end)

    {Map.delete(map, pp), pp}
  end
end
