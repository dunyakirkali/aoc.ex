defmodule Aoc.Day8 do
  @doc """
      iex> "priv/day8/example.txt" |> Aoc.Day8.input() |> Aoc.Day8.part1()
      4

      iex> "priv/day8/example2.txt" |> Aoc.Day8.input() |> Aoc.Day8.part1()
      14
  """
  def part1(list) do
    list
    |> Enum.filter(fn {_, char} -> char != "." end)
    |> Enum.group_by(fn {_, an} -> an end)
    |> Enum.map(fn {an, poss} ->
      {an, Enum.map(poss, fn {p, _} -> p end)}
    end)
    |> Enum.flat_map(fn {an, poss} ->
      poss
      |> Comb.combinations(2)
      |> Enum.flat_map(fn [{xa, ya}, {xb, yb}] ->
        {dx, dy} = {xa - xb, ya - yb}

        [
          {xb - dx, yb - dy},
          {xa + dx, ya + dy}
        ]
      end)
    end)
    |> Enum.uniq()
    |> Enum.filter(fn {x, y} ->
      {sx, sy} = size(list)
      x >= 0 and x <= sx and y >= 0 and y <= sy
    end)
    |> Enum.count()
  end

  def size(map) do
    {max_x, max_y} =
      map
      |> Enum.reduce({0, 0}, fn {{x, y}, _}, {max_x, max_y} ->
        {max(x, max_x), max(y, max_y)}
      end)

    {max_x, max_y}
  end

  @doc """
      iex> "priv/day8/example3.txt" |> Aoc.Day8.input() |> Aoc.Day8.part2()
      9

      iex> "priv/day8/example2.txt" |> Aoc.Day8.input() |> Aoc.Day8.part2()
      34
  """
  def part2(list) do
    list
    |> Enum.filter(fn {_, char} -> char != "." end)
    |> Enum.group_by(fn {_, an} -> an end)
    |> Enum.map(fn {an, poss} ->
      {an, Enum.map(poss, fn {p, _} -> p end)}
    end)
    |> Enum.flat_map(fn {an, poss} ->
      poss
      |> Comb.combinations(2)
      |> Enum.flat_map(fn [{xa, ya}, {xb, yb}] ->
        {dx, dy} = {xa - xb, ya - yb}

        [
          step({xa, ya}, {dx, dy}, size(list), []),
          step({xb, yb}, {-dx, -dy}, size(list), [])
        ]
      end)
    end)
    |> List.flatten()
    |> Enum.uniq()
    |> Enum.filter(fn {x, y} ->
      {sx, sy} = size(list)
      x >= 0 and x <= sx and y >= 0 and y <= sy
    end)
    |> Enum.count()
  end

  def step({cx, cy}, {dx, dy}, {sx, sy}, acc) do
    if cx < 0 or cx > sx or cy < 0 or cy > sy do
      acc
    else
      step({cx + dx, cy + dy}, {dx, dy}, {sx, sy}, [{cx, cy} | acc])
    end
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
        {{x, y}, char}
      end)
    end)
    |> Enum.into(%{})
  end
end
