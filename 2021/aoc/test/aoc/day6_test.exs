defmodule Day6Test do
  use ExUnit.Case
  doctest Aoc.Day6

  test "Part 1" do
    input = Aoc.Day6.input("priv/day6/input.txt")
    assert Aoc.Day6.part1(input) == 360_268
  end

  test "Part 2" do
    input = Aoc.Day6.input("priv/day6/input.txt")
    assert Aoc.Day6.part2(input) == 1_632_146_183_902
  end
end
