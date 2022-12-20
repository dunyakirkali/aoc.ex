defmodule Day19Test do
  use ExUnit.Case
  doctest Aoc.Day19

  @tag timeout: :infinity
  test "Part 1" do
    input = Aoc.Day19.input("priv/day19/input.txt")
    assert Aoc.Day19.part1(input) == 1650
  end

  @tag timeout: :infinity
  test "Part 2" do
    input = Aoc.Day19.input("priv/day19/input.txt")
    assert Aoc.Day19.part2(input) == 5824
  end
end
