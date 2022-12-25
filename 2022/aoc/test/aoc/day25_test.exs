defmodule Day25Test do
  use ExUnit.Case
  doctest Aoc.Day25

  test "Part 1" do
    input = Aoc.Day25.input("priv/day25/input.txt")
    assert Aoc.Day25.part1(input) == "2-20=01--0=0=0=2-120"
  end
end
