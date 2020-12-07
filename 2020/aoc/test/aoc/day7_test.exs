defmodule Day7Test do
  use ExUnit.Case
  doctest Aoc.Day7

  test "Part 1" do
    input = Aoc.Day7.input("priv/day7/input.txt")
    assert Aoc.Day7.part1(input) == 233
  end

  test "Part 2" do
    input = Aoc.Day7.input("priv/day7/input.txt")
    assert Aoc.Day7.part2(input) == 3122
  end
end
