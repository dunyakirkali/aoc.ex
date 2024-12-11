defmodule Day11Test do
  use ExUnit.Case
  doctest Aoc.Day11

  test "Part 1" do
    input = Aoc.Day11.input("priv/day11/input.txt")
    assert Aoc.Day11.part1(input, 25) |> Enum.count() == 197_157
  end

  test "Part 2" do
    input = Aoc.Day11.input("priv/day11/input.txt")
    assert Aoc.Day11.part2(input) == 234_430_066_982_597
  end
end
