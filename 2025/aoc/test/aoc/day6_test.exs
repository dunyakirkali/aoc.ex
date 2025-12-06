defmodule Day6Test do
  use ExUnit.Case
  doctest Aoc.Day6

  test "Part 1" do
    input = Aoc.Day6.input("priv/day6/input.txt")
    assert Aoc.Day6.part1(input) == 5_784_380_717_354
  end

  @tag timeout: :infinity
  test "Part 2" do
    input = Aoc.Day6.input("priv/day6/input.txt")
    assert Aoc.Day6.part2(input) == 7_996_215_336_396
  end
end
