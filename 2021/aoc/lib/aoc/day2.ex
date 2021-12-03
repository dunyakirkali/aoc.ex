defmodule Aoc.Day2 do
  @doc """
      iex> Aoc.Day2.input("priv/day2/example.txt") |> Aoc.Day2.part1()
      150
  """
  def part1(input) do
    {x, y} =
      input
      |> Enum.reduce({0, 0}, fn line, {x, y} ->
        case line do
          {"forward", am} ->
            {x + am, y}

          {"up", am} ->
            {x, y - am}

          {"down", am} ->
            {x, y + am}
        end
      end)

    x * y
  end

  @doc """
      iex> Aoc.Day2.input("priv/day2/example.txt") |> Aoc.Day2.part2()
      900
  """
  def part2(input) do
    {x, y, _} =
      input
      |> Enum.reduce({0, 0, 0}, fn line, {x, y, aim} ->
        case line do
          {"forward", am} ->
            {x + am, y + aim * am, aim}

          {"up", am} ->
            {x, y, aim - am}

          {"down", am} ->
            {x, y, aim + am}
        end
      end)

    x * y
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Stream.map(fn line ->
      [dir, am] = String.split(line, " ")
      {dir, String.to_integer(am)}
    end)
  end
end
