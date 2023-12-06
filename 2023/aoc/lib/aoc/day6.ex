defmodule Aoc.Day6 do
  @doc """
      iex> "priv/day6/example.txt" |> Aoc.Day6.input() |> Aoc.Day6.part1()
      288
  """
  def part1(input) do
    calc(input)
  end

  def calc(input) do
    input
    |> Enum.map(fn {_race, {time, distance}} ->
      Stream.iterate(0, &(&1 + 1))
      |> Enum.take_while(fn x -> x <= time end)
      |> Stream.filter(fn wait ->
        wait + wait * (time - wait - 1) > distance
      end)
      |> Enum.to_list()
    end)
    |> Enum.map(&Enum.count/1)
    |> Enum.reduce(1, fn count, acc -> count * acc end)
  end

  @doc """
      iex> "priv/day6/example.txt" |> Aoc.Day6.input(:part2) |> Aoc.Day6.part2()
      71503
  """
  def part2(input) do
    calc(input)
  end

  def input(filename, part \\ :part1) do
    secas =
      filename
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [_, vs] = String.split(line, ~r/:\s+/)

        if part == :part1 do
          String.split(vs, ~r/\s+/)
          |> Enum.map(&String.to_integer/1)
        else
          [
            String.replace(vs, " ", "")
            |> String.to_integer()
          ]
        end
      end)

    0..(Enum.count(Enum.at(secas, 0)) - 1)
    |> Enum.to_list()
    |> Enum.reduce(%{}, fn i, acc ->
      Map.put(acc, i, {Enum.at(Enum.at(secas, 0), i), Enum.at(Enum.at(secas, 1), i)})
    end)
  end
end
