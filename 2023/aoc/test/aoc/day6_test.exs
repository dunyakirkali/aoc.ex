defmodule Day6Test do
  use ExUnit.Case
  doctest Aoc.Day6

  test "Part 1" do
    input = Aoc.Day6.input("priv/day6/input.txt")
    assert Aoc.Day6.part1(input) == 2_065_338
  end

  test "Part 2" do
    input = Aoc.Day6.input("priv/day6/input.txt", :part2)
    assert Aoc.Day6.part2(input) == 34_934_171
  end
end
