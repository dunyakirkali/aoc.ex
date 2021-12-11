defmodule Aoc.Day11 do
  @doc """
      iex> input = Aoc.Day11.input("priv/day11/example2.txt")
      ...> Aoc.Day11.part1(input, 2)
      9

      iex> input = Aoc.Day11.input("priv/day11/example.txt")
      ...> Aoc.Day11.part1(input, 1)
      0

      iex> input = Aoc.Day11.input("priv/day11/example.txt")
      ...> Aoc.Day11.part1(input, 10)
      204

      iex> input = Aoc.Day11.input("priv/day11/example.txt")
      ...> Aoc.Day11.part1(input, 100)
      1656
  """
  def part1(input, steps) do
    input
    |> Stream.iterate(&step/1)
    |> Stream.take(steps + 1)
    |> Stream.map(fn map ->
      Enum.count(map, fn {_pos, value} -> value == 0 end)
    end)
    |> Enum.sum()
  end

  def step(input) do
    input
    |> Enum.reduce(input, fn {pos, _value}, map ->
      increase(map, pos)
    end)
    |> go_out()
  end

  defp increase(map, pos) do
    case map do
      %{^pos => 9} ->
        flash(map, pos)

      %{^pos => n} ->
        Map.put(map, pos, n + 1)

      %{} ->
        map
    end
  end

  defp flash(map, {col, row} = pos) do
    map
    |> Map.update!(pos, &(&1 + 1))
    |> increase({col + 1, row - 1})
    |> increase({col + 1, row})
    |> increase({col + 1, row + 1})
    |> increase({col - 1, row - 1})
    |> increase({col - 1, row})
    |> increase({col - 1, row + 1})
    |> increase({col, row + 1})
    |> increase({col, row - 1})
  end

  defp go_out(map) do
    Map.new(map, fn
      {pos, value} when value > 9 ->
        {pos, 0}

      other ->
        other
    end)
  end

  @doc """
      # iex> input = Aoc.Day11.input("priv/day11/example.txt")
      # ...> Aoc.Day11.part2(input)
      # 195
  """
  def part2(input) do
    input
    |> Stream.iterate(&step/1)
    |> Stream.take_while(fn map ->
      Enum.any?(map, fn {_pos, value} -> value != 0 end)
    end)
    |> Enum.count()
  end

  def input(filename) do
    filename
    |> Aoc.Chart.new
  end
end
