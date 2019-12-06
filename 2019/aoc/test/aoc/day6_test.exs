defmodule Day6Test do
  use ExUnit.Case
  doctest Aoc.Day6

  test "Part 1" do
    assert Aoc.Day6.part1("priv/day6/input.txt") == 144909
  end

  test "Part 2" do
    assert Aoc.Day6.part2("priv/day6/input.txt") == 259
  end

  test "Part 2 - Digraph" do
    assert Aoc.Day6.part2d("priv/day6/input.txt") == 259
  end
end
