defmodule Day1Test do
  use ExUnit.Case
  doctest Aoc.Day1

  test "Part 1" do
    input = Aoc.Day1.input("priv/day1/input.txt")
    assert Aoc.Day1.part1(input) == 53_386
  end

  test "Part 2" do
    input = Aoc.Day1.input("priv/day1/input.txt")
    assert Aoc.Day1.part2(input) == 53_312
  end
end