defmodule Day15Test do
  use ExUnit.Case
  doctest Aoc.Day15

  test "Part 1" do
    input = Aoc.Day15.input("priv/day15/input.txt")
    assert Aoc.Day15.part1(input) == 516_804
  end

  test "Part 2" do
    input = Aoc.Day15.input("priv/day15/input.txt")
    assert Aoc.Day15.part2(input) == 231_844
  end
end
