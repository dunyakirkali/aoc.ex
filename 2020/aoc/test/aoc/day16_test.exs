defmodule Day16Test do
  use ExUnit.Case
  doctest Aoc.Day16

  test "Part 1" do
    inp = Aoc.Day16.input("priv/day16/input.txt")
    assert Aoc.Day16.part1(inp) == 25961
  end

  test "Part 2" do
    inp = Aoc.Day16.input("priv/day16/input.txt")
    assert Aoc.Day16.part2(inp) == 1_801_753
  end
end
