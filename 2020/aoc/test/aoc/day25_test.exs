defmodule Day25Test do
  use ExUnit.Case
  doctest Aoc.Day25

  test "Part 1" do
    assert Aoc.Day25.part1(1526110, 20175123, 9_000_000) == 254
  end
end
