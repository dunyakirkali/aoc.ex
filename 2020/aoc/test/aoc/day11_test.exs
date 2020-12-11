defmodule Day11Test do
  use ExUnit.Case
  doctest Aoc.Day11

  test "Part 1" do
    assert Aoc.Day11.part1("priv/day11/input.txt") == 2494
  end

  test "Part 2" do
    assert Aoc.Day11.part2("priv/day11/input.txt") == 2306
  end
end
