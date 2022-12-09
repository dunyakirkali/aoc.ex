defmodule Day9Test do
  use ExUnit.Case
  doctest Aoc.Day9

  test "Part 1" do
    input = Aoc.Day9.input("priv/day9/input.txt")
    assert Aoc.Day9.part1(input) == 6190
  end

  test "Part 2" do
    input = Aoc.Day9.input("priv/day9/input.txt")
    assert Aoc.Day9.part2(input) == 2516
  end
end
