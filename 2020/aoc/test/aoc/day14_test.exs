defmodule Day14Test do
  use ExUnit.Case
  doctest Aoc.Day14

  test "Part 1" do
    inp = Aoc.Day14.input("priv/day14/input.txt")
    assert Aoc.Day14.part1(inp) == 17_934_269_678_453
  end

  test "Part 2" do
    inp = Aoc.Day14.input("priv/day14/input.txt")
    assert Aoc.Day14.part2(inp) == 3_440_662_844_064
  end
end
