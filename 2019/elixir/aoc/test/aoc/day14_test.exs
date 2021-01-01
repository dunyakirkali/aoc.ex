defmodule Day14Test do
  use ExUnit.Case
  doctest Aoc.Day14

  test "Part 1" do
    assert Aoc.Day14.part1("priv/day14/input.txt") == 202617
  end

  test "Part 2" do
    assert Aoc.Day14.part2("priv/day14/input.txt") == 7863863
  end
end
