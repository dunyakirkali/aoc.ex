defmodule Day2Test do
  use ExUnit.Case
  doctest Aoc.Day2

  test "Part 1" do
    input = Aoc.Day2.input("priv/day2/input.txt")
    assert Aoc.Day2.part1(input) == 2776
  end

  test "Part 2" do
    input = Aoc.Day2.input("priv/day2/input.txt")
    assert Aoc.Day2.part2(input) == 68638
  end
end
