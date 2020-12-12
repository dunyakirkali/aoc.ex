defmodule Day12Test do
  use ExUnit.Case
  doctest Aoc.Day12

  test "Part 1" do
    inp = Aoc.Day12.input("priv/day12/input.txt")
    assert Aoc.Day12.part1(inp) == 938
  end

  test "Part 2" do
    inp = Aoc.Day12.input("priv/day12/input.txt")
    assert Aoc.Day12.part2(inp) == 54404
  end
end
