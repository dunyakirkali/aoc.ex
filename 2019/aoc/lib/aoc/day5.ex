defmodule Aoc.Day5 do
  def part1() do
    "priv/day5/input.txt"
    |> AGC.new()
    |> Map.put(:input, 1)
    |> AGC.run()
  end

  def part2() do
    "priv/day5/input.txt"
    |> AGC.new()
    |> Map.put(:input, 5)
    |> AGC.run()
  end
end
