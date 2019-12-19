defmodule Aoc.Day19 do
  use Memoize

  @size 100

  def part1() do
    map = for x <- 0..49, y <- 0..49, do: {x, y}
    machine = AGC.new("priv/day19/input.txt")
    map
    |> Stream.map(fn {x, y} ->
      machine
      |> Map.put(:inputs, [x, y])
      |> AGC.run
      |> Map.get(:output)
      |> List.last
    end)
    |> Stream.filter(fn res ->
      res == 1
    end)
    |> Enum.count
  end

  def part2() do

    machine = AGC.new("priv/day19/input.txt")

    solve(machine, {0, 0}, Map.new, false)
  end

  def solve(_, {x, y}, acc, _) when x == @size and y == @size, do: acc
  def solve(machine, {x, y}, acc, _) when x == @size, do: solve(machine, {0, y + 1}, acc, false)
  def solve(machine, {x, y}, acc, aso) do
    IO.inspect(acc)
    IO.inspect(((y + 1) * @size + (x + 1)) / (@size * @size))
    {machine, acc} = calculate(machine, {x, y}, acc)
    if is_integer(acc) do
      acc
    else
      if get_max(acc, {x, y}) == 0 and aso do
        solve(machine, {0, y + 1}, acc, false)
      else
        value = get(machine, {x, y})
        solve(machine, {x + 1, y}, acc, value == 1)
      end
    end
  end

  defmemo calculate(machine, {x, y}, acc) do
    value = get(machine, {x, y})
    acc =
      if value == 0 do
        acc
      else
        min_x = get_max(acc, {x - 1, y})
        min_y = get_max(acc, {x, y - 1})
        min_x_y = get_max(acc, {x - 1, y - 1})
        min = min(min(min_x, min_y), min_x_y)
        Map.put(acc, {x, y}, min + 1)
      end

    if Map.get(acc, {x, y}) == 100 do
      {machine, (x - 99) * 10_000 + (y - 99)}
    else
      {machine, acc}
    end
  end

  defmemo get_max(map, pos) do
    Map.get(map, pos, 0)
  end

  defmemo get(machine, {x, y}) do
    machine
    |> Map.put(:inputs, [x, y])
    |> AGC.run
    |> Map.get(:output)
    |> List.last
  end
end
