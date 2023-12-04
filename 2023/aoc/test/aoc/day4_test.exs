defmodule Day4Test do
  use ExUnit.Case
  doctest Aoc.Day4

  test "Part 1" do
    input = Aoc.Day4.input("priv/day4/input.txt")
    assert Aoc.Day4.part1(input) == 23941
  end

  test "Part 2" do
    input = Aoc.Day4.input("priv/day4/input.txt")
    assert Aoc.Day4.part2(input) == 5_571_760
  end
end
