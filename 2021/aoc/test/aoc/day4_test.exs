defmodule Day4Test do
  use ExUnit.Case
  doctest Aoc.Day4

  test "Part 1" do
    input = Aoc.Day4.input("priv/day4/input.txt")
    assert Aoc.Day4.part1(input) == 2745
  end

  test "Part 2" do
    input = Aoc.Day4.input("priv/day4/input.txt")
    assert Aoc.Day4.part2(input) == 6594
  end
end
