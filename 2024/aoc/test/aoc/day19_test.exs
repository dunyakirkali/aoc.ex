defmodule Day19Test do
  use ExUnit.Case
  doctest Aoc.Day19

  test "Part 1" do
    input = Aoc.Day19.input("priv/day19/input.txt")
    assert Aoc.Day19.part1(input) == 315
  end

  test "Part 2" do
    input = Aoc.Day19.input("priv/day19/input.txt")
    assert Aoc.Day19.part2(input) == 625_108_891_232_249
  end
end
