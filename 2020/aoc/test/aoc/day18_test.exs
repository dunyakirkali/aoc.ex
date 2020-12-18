defmodule Day18Test do
  use ExUnit.Case
  doctest Aoc.Day18

  test "Part 1" do
    inp = Aoc.Day18.input("priv/day18/input.txt")
    assert Aoc.Day18.part1(inp) == 6_811_433_855_019
  end

  test "Part 2" do
    inp = Aoc.Day18.input("priv/day18/input.txt")
    assert Aoc.Day18.part2(inp) == 129_770_152_447_927
  end
end
