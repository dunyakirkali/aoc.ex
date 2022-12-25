defmodule Day13Test do
  use ExUnit.Case
  doctest Aoc.Day13

  test "Part 1" do
    input = Aoc.Day13.input("priv/day13/input.txt")
    assert Aoc.Day13.part1(input) == 4809
  end

  test "Part 2" do
    input = Aoc.Day13.input("priv/day13/input.txt")
    assert Aoc.Day13.part2(input) == 22600
  end
end
