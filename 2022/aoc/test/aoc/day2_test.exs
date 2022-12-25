defmodule Day2Test do
  use ExUnit.Case
  doctest Aoc.Day2

  test "Part 1" do
    input = Aoc.Day2.input("priv/day2/input.txt")
    assert Aoc.Day2.part1(input) == 13484
  end

  test "Part 2" do
    input = Aoc.Day2.input("priv/day2/input.txt")
    assert Aoc.Day2.part2(input) == 13433
  end
end
