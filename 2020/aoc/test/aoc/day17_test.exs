defmodule Day17Test do
  use ExUnit.Case
  doctest Aoc.Day17

  test "Part 1" do
    assert Aoc.Day17.part1("priv/day17/input.txt") == 338
  end

  test "Part 2" do
    assert Aoc.Day17.part2("priv/day17/input.txt") == 2440
  end
end
