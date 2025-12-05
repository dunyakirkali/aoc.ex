defmodule Aoc.Day5 do
  @doc """
      iex> "priv/day5/example.txt" |> Aoc.Day5.input() |> Aoc.Day5.part1()
      3
  """
  def part1({ranges, nums}) do
    nums
    |> Enum.filter(fn n ->
      Enum.any?(ranges, fn r -> n in r end)
    end)
    |> length()
  end

  @doc """
      iex> "priv/day5/example.txt" |> Aoc.Day5.input() |> Aoc.Day5.part2()
      14
  """
  def part2({ranges, _nums}) do
    ranges
    |> Enum.sort_by(& &1.first)
    |> merge_ranges()
    |> Enum.map(fn {s, e} -> e - s + 1 end)
    |> Enum.sum()
  end

  defp merge_ranges(ranges) do
    Enum.reduce(ranges, [], fn range, acc ->
      {start, stop} = {range.first, range.last}

      case acc do
        [] ->
          [{start, stop}]

        [{ps, pe} | rest] ->
          if start <= pe + 1 do
            [{ps, max(pe, stop)} | rest]
          else
            [{start, stop} | acc]
          end
      end
    end)
    |> Enum.reverse()
  end

  def input(filename) do
    [f, r] =
      filename
      |> File.read!()
      |> String.split("\n\n", trim: true)

    ranges =
      f
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [s, e] =
          line
          |> String.split("-", trim: true)
          |> Enum.map(&String.to_integer/1)

        Range.new(s, e)
      end)

    nums =
      r
      |> String.split("\n", trim: true)
      |> Enum.map(&String.to_integer/1)

    {ranges, nums}
  end
end
