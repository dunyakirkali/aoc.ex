defmodule Day16Test do
  use ExUnit.Case
  doctest Aoc.Day16

  test "Part 1" do
    input = Aoc.Day16.input("priv/day16/input.txt")
    assert Aoc.Day16.part1(input) == 925
  end

  test "Part 2" do
    input = Aoc.Day16.input("priv/day16/input.txt")
    assert Aoc.Day16.part2(input) == 342_997_120_375
  end
end
