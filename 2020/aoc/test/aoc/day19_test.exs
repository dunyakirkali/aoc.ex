defmodule Day19Test do
  use ExUnit.Case
  doctest Aoc.Day19

  test "Part 1" do
    inp = Aoc.Day19.input("priv/day19/input.txt")
    assert Aoc.Day19.part1(inp) == 187
  end

  test "Part 2" do
    inp = Aoc.Day19.input("priv/day19/input.txt")
    assert Aoc.Day19.part2(inp) == 392
  end
end
