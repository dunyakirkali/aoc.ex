defmodule Day3Test do
  use ExUnit.Case
  doctest Aoc.Day3

  test "Part 1" do
    input = Aoc.Day3.input("priv/day3/input.txt")
    assert Aoc.Day3.part1(input) == 841_526
  end

  test "Part 2" do
    input = Aoc.Day3.input("priv/day3/input.txt")
    assert Aoc.Day3.part2(input) == 4_790_390
  end
end
