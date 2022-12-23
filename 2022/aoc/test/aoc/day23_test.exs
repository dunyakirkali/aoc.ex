defmodule Day23Test do
  use ExUnit.Case
  doctest Aoc.Day23

  test "Part 1" do
    input = Aoc.Day23.input("priv/day23/input.txt")
    assert Aoc.Day23.part1(input) == 4302
  end

  test "Part 2" do
    input = Aoc.Day23.input("priv/day23/input.txt")
    assert Aoc.Day23.part2(input) == 1025
  end
end
