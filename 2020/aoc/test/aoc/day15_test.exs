defmodule Day15Test do
  use ExUnit.Case
  doctest Aoc.Day15

  test "Part 1" do
    assert Aoc.Day15.part1("6,19,0,5,7,13,1") == 468
  end

  test "Part 2" do
    assert Aoc.Day15.part2("6,19,0,5,7,13,1") == 1_801_753
  end
end
