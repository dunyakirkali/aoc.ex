defmodule Aoc.Day19 do
  def part1() do
    rows(50)
    |> Stream.map(& &1.count)
    |> Enum.sum()
  end

  def part2() do
    square =
      rows(10_000)
      |> largest_squares()
      |> Enum.find(&(&1.dimension == 100)
    )
    square.x * 10_000 + square.y
  end

  def rows(upto) do
    machine = AGC.new("priv/day19/input.txt")
    Stream.unfold({0, 0, 0}, fn {y, start_x, last_count} ->
      max_x = upto

      offset = Enum.find_index(statuses(machine, y, start_x, max_x), &(&1 == :full))

      if is_nil(offset) do
        {%{y: y, from: nil, count: 0}, {y + 1, start_x, last_count}}
      else
        from = start_x + offset
        start_scan = min(start_x + last_count, upto - 1)

        count =
          statuses(machine, y, start_scan, upto)
          |> Stream.take_while(&(&1 == :full))
          |> Enum.count()

        final_count = count + start_scan - from
        {%{y: y, from: from, count: final_count}, {y + 1, from, final_count}}
      end
    end)
    |> Stream.take(upto)
  end

  defp largest_squares(pulls) do
    pulls
    |> Stream.chunk_every(100, 1, :discard)
    |> Stream.map(&largest_square/1)
    |> Stream.reject(&is_nil/1)
  end

  defp largest_square(pulls) do
    if Enum.any?(pulls, &(&1.count == 0)) do
      nil
    else
      left = pulls |> Stream.map(& &1.from) |> Enum.max()
      right = pulls |> Stream.map(&(&1.from + &1.count - 1)) |> Enum.min()
      dimension = min(right - left + 1, length(pulls))
      %{y: hd(pulls).y, x: left, dimension: dimension}
    end
  end

  def statuses(machine, y, from, to) do
    from
    |> Stream.iterate(&(&1 + 1))
    |> Stream.take_while(&(&1 < to))
    |> Stream.map(&get(machine, {&1, y}))
  end

  def get(machine, {x, y}) do
    case machine |> Map.put(:inputs, [x, y]) |> AGC.run() |> Map.get(:output) do
      [0] -> :void
      [1] -> :full
    end
  end
end
