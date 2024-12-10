defmodule Aoc.Day10 do
  @doc """
      iex> "priv/day10/example.txt" |> Aoc.Day10.input() |> Aoc.Day10.part1()
      1
  """
  def part1(list) do
    visited = MapSet.new()

    trailheads =
      Enum.filter(list, fn {_, char} -> char == 0 end)

    trailends =
      Enum.filter(list, fn {_, char} -> char == 9 end)

    combinations =
      for(
        x <- Enum.map(trailends, fn {p, _} -> p end),
        y <- Enum.map(trailheads, fn {p, _} -> p end),
        do: {x, y}
      )

    paths =
      trailheads
      |> Enum.map(fn {pos, _} -> pos end)
      |> Enum.map(fn pos -> solve(list, pos, visited) end)
      |> List.flatten()
      |> Enum.uniq()

    combinations
    |> Enum.filter(fn {s, e} ->
      Enum.any?(paths, fn path ->
        MapSet.member?(path, s) and MapSet.member?(path, e)
      end)
    end)
    |> Enum.count()
  end

  def solve(list, {nx, ny}, visited) do
    cval = Map.get(list, {nx, ny})

    if MapSet.member?(visited, {nx, ny}) do
      0
    else
      if cval == 9 do
        MapSet.put(visited, {nx, ny})
      else
        neighbors()
        |> Enum.map(fn {dx, dy} ->
          {nx + dx, ny + dy}
        end)
        |> Enum.filter(fn {x, y} -> Map.get(list, {x, y}, 0) == cval + 1 end)
        |> Enum.map(fn pos -> solve(list, pos, MapSet.put(visited, {nx, ny})) end)
      end
    end
  end

  @doc """
      iex> "priv/day10/example4.txt" |> Aoc.Day10.input() |> Aoc.Day10.part2()
      81
  """
  def part2(list) do
    visited = MapSet.new()

    trailheads =
      Enum.filter(list, fn {_, char} -> char == 0 end)

    trailends =
      Enum.filter(list, fn {_, char} -> char == 9 end)

    combinations =
      for(
        x <- Enum.map(trailends, fn {p, _} -> p end),
        y <- Enum.map(trailheads, fn {p, _} -> p end),
        do: {x, y}
      )

    paths =
      trailheads
      |> Enum.map(fn {pos, _} -> pos end)
      |> Enum.map(fn pos -> solve(list, pos, visited) end)
      |> List.flatten()
      |> Enum.uniq()

    combinations
    |> Enum.map(fn {s, e} ->
      Enum.filter(paths, fn path ->
        MapSet.member?(path, s) and MapSet.member?(path, e)
      end)
      |> Enum.count()
    end)
    |> Enum.sum()
  end

  defp neighbors do
    [
      {1, 0},
      {0, 1},
      {0, -1},
      {-1, 0}
    ]
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.flat_map(fn {line, y} ->
      line
      |> String.split("", trim: true)
      |> Enum.with_index()
      |> Enum.map(fn {char, x} ->
        {{x, y}, String.to_integer(char)}
      end)
    end)
    |> Enum.into(%{})
  end
end
