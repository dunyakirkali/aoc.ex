defmodule Day25Test do
  use ExUnit.Case
  doctest Aoc.Day25

  test "Part 1" do
    inp = Aoc.Day25.input("priv/day25/input.txt")
    assert Aoc.Day25.part1(inp) == 10_924_063
  end
end
