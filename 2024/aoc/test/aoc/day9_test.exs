defmodule Day9Test do
  use ExUnit.Case
  doctest Aoc.Day9

  test "Part 1" do
    input = Aoc.Day9.input("priv/day9/input.txt")
    assert Aoc.Day9.part1(input) == 6_154_342_787_400
  end

  test "Part 2" do
    input = Aoc.Day9.input("priv/day9/input.txt")
    assert Aoc.Day9.part2(input) == 6_183_632_723_350
  end
end
