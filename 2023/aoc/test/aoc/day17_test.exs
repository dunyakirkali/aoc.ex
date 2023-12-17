defmodule Day17Test do
  use ExUnit.Case
  doctest Aoc.Day17

  test "Part 1" do
    input = Aoc.Day17.input("priv/day17/input.txt")
    assert Aoc.Day17.part1(input) == 1128
  end

  test "Part 2" do
    input = Aoc.Day17.input("priv/day17/input.txt")
    assert Aoc.Day17.part2(input) == 1268
  end
end
