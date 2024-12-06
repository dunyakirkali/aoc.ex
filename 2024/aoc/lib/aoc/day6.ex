defmodule Aoc.Day6 do
  @doc """
      iex> "priv/day6/example.txt" |> Aoc.Day6.input() |> Aoc.Day6.part1()
      41
  """
  def part1(list) do
    {m, c} = list

    Stream.iterate(1, &(&1 + 1))
    |> Enum.reduce_while({m, c, "^", [{c, "^"}]}, fn _, {map, cp, dir, visited} ->
      {cx, cy} = cp
      np = dir(dir, {cx, cy})
      case Map.get(map, np, " ") do
        # Turn 90
        "#" -> {:cont, {map, {cx, cy}, turn(dir), visited}}
        "." -> {:cont, {map, np, dir, [{np, dir} | visited]}}
        " " -> {:halt, visited}
      end
    end)
    |> Enum.map(fn {k, _} -> k end)
    |> Enum.uniq()
    |> Enum.count()
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
    all_empty =
      Stream.iterate(1, &(&1 + 1))
      |> Enum.reduce_while({m, c, "^", [{c, "^"}]}, fn _, {map, cp, dir, visited} ->
        {cx, cy} = cp
        np = dir(dir, {cx, cy})
        case Map.get(map, np, " ") do
          # Turn 90
          "#" -> {:cont, {map, {cx, cy}, turn(dir), visited}}
          "." -> {:cont, {map, np, dir, [{np, dir} | visited]}}
          " " -> {:halt, visited}
        end
      end)
      |> Enum.map(fn {k, _} -> k end)
      |> Enum.uniq()


    all_empty
    |> Enum.map(fn obstacle ->
      Stream.iterate(1, &(&1 + 1))
      |> Enum.reduce_while({Map.put(m, obstacle, "#"), c, "^", [{c, "^"}]}, fn _, {map, cp, dir, visited} ->
        {cx, cy} = cp
        np = dir(dir, {cx, cy})
        case Map.get(map, np, " ") do
          "#" -> {:cont, {map, {cx, cy}, turn(dir), visited}}
          "." ->
            if Enum.member?(visited, {np, dir}) do
              {:halt, 1}
            else
              {:cont, {map, np, dir, [{np, dir} | visited]}}
            end
          " " -> {:halt, 0}
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

    {Map.put(map, pp, "."), pp}
  end
end
