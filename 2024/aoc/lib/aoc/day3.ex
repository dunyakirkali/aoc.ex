defmodule Aoc.Day3 do
  @doc """
      iex> "priv/day3/example.txt" |> Aoc.Day3.input() |> Aoc.Day3.part1()
      161
  """
  def part1(list) do
    Regex.scan(~r/mul\((\d{0,3}),(\d{0,3})\)/, list)
    |> Enum.map(fn mul ->
      Enum.drop(mul, 1)
      |> Enum.map(&String.to_integer/1)
      |> Enum.reduce(&Kernel.*/2)
    end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day3/example2.txt" |> Aoc.Day3.input() |> Aoc.Day3.part2()
      48
  """
  def part2(list) do
    {_, count} =
      Regex.scan(~r/(?:mul|do|don't)\((\d{0,3}),?(\d{0,3})?\)/, list)
      |> Enum.reduce({true, 0}, fn cmd, {mul, sum} ->
        case cmd do
          ["do()", "", ""] ->
            {true, sum}

          ["don't()", "", ""] ->
            {false, sum}

          [_, a, b] ->
            if mul do
              {mul, String.to_integer(a) * String.to_integer(b) + sum}
            else
              {mul, sum}
            end
        end
      end)

    count
  end

  def input(filename) do
    filename
    |> File.read!()
  end
end
