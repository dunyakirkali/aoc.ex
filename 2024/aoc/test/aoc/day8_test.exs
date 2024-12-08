defmodule Day8Test do
  use ExUnit.Case
  doctest Aoc.Day8

  test "Part 1" do
    input = Aoc.Day8.input("priv/day8/input.txt")
    assert Aoc.Day8.part1(input) == 354
  end

  test "Part 2" do
    input = Aoc.Day8.input("priv/day8/input.txt")
    assert Aoc.Day8.part2(input) == 1263
  end
end
