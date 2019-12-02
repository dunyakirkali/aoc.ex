defmodule Aoc.Day2 do
  def part1() do
    AGC.new("priv/day2/input.txt")
    |> AGC.set(12, 2)
    |> AGC.run
  end

  def part2(goal) do
    machine = AGC.new("priv/day2/input.txt")
    {noun, verb} =
      for(noun <- 0..99, verb <- 0..99, do: {noun, verb})
      |> Enum.find(fn {noun, verb} ->
        machine
        |> AGC.set(noun, verb)
        |> AGC.run
        |> Kernel.==(goal)
      end)
    100 * noun + verb
  end
end
