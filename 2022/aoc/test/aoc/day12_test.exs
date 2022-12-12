defmodule Day12Test do
  use ExUnit.Case
  doctest Aoc.Day12

  test "Part 1" do
    input = Aoc.Day12.input("priv/day12/input.txt")
    assert Aoc.Day12.part1(input) == 408
  end

  test "Part 2" do
    input = Aoc.Day12.input("priv/day12/input.txt")
    assert Aoc.Day12.part2(input) == 399
  end
end
