defmodule Day3Test do
  use ExUnit.Case
  doctest Aoc.Day3

  test "Part 1" do
    input = Aoc.Day3.input()
    assert Aoc.Day3.part1(input) == 2592
  end

  test "Part 2" do
    input = Aoc.Day3.input()
    assert Aoc.Day3.part2(input) == 2360
  end
end
