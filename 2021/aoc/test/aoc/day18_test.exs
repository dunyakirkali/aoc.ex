defmodule Day18Test do
  use ExUnit.Case
  doctest Aoc.Day18

  test "Part 1" do
    input = Aoc.Day18.input("priv/day18/input.txt")
    assert Aoc.Day18.part1(input) == 4111
  end

  test "Part 2" do
    input = Aoc.Day18.input("priv/day18/input.txt")
    assert Aoc.Day18.part2(input) == 4917
  end
end
