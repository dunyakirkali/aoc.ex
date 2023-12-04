defmodule Day3Test do
  use ExUnit.Case
  doctest Aoc.Day3

  test "Part 1" do
    input = "priv/day3/input.txt"
    assert Aoc.Day3.part1(input) == 529_618
  end

  test "Part 2" do
    input = "priv/day3/input.txt"
    assert Aoc.Day3.part2(input) == 77_509_019
  end
end
