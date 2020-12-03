defmodule Aoc.Day3 do
  @doc """
      iex> chart = Aoc.Chart.new("priv/day3/example.txt")
      ...> Aoc.Day3.part1(chart, {3, 1})
      7
  """
  def part1(chart, {mx, my}) do
    rows = Aoc.Chart.number_of_rows(chart)
    cols = Aoc.Chart.number_of_cols(chart)
    slide(chart, {0, 0}, {mx, my}, {rows, cols}, 0)
  end

  def slide(_chart, {_cx, cy}, {_mx, _my}, {rows, _cols}, encountered) when cy >= rows,
    do: encountered

  def slide(chart, {cx, cy}, {mx, my}, {rows, cols}, encountered) do
    current_tile = Map.get(chart, {cx, cy})
    new_encountered = if current_tile == "#", do: encountered + 1, else: encountered
    slide(chart, {rem(cx + mx, cols), cy + my}, {mx, my}, {rows, cols}, new_encountered)
  end

  @doc """
      iex> chart = Aoc.Chart.new("priv/day3/example.txt")
      ...> Aoc.Day3.part2(chart)
      336
  """
  def part2(inp) do
    [{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
    |> Enum.map(fn slope ->
      Aoc.Day3.part1(inp, slope)
    end)
    |> Enum.reduce(1, fn value, acc ->
      acc * value
    end)
  end
end
