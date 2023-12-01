defmodule Aoc.Day1 do
  @doc """
      iex> "priv/day1/example.txt" |> Aoc.Day1.input() |> Aoc.Day1.part1()
      24000
  """
  def part1(list) do
    list
    |>IO.inspect()
		|> Enum.sum()
  end

  @doc """
      iex> "priv/day1/example.txt" |> Aoc.Day1.input() |> Aoc.Day1.part2()
      45000
  """
  def part2(list) do
    list
    |> Enum.map(&Enum.sum/1)
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.sum()
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      numbers =
				line
				|> String.graphemes()
				|> Enum.map(fn x ->
					case Integer.parse(x) do
						{num, _} -> num
						_ -> nil
					end
				end)
				|> Enum.filter(& !is_nil(&1))
			fi = List.first(numbers)
			la = List.last(numbers)

			[fi, la]|> Integer.undigits()
    end)
  end
end
