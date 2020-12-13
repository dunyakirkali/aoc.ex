defmodule Day13Test do
  use ExUnit.Case
  doctest Aoc.Day13

  test "Part 1" do
    inp = Aoc.Day13.input("priv/day13/input.txt")
    assert Aoc.Day13.part1(inp) == 2406
  end

  test "Part 2" do
    inp = Aoc.Day13.input("priv/day13/input.txt")
    assert Aoc.Day13.part2(inp) == 225_850_756_401_039
  end
end
