defmodule Day6Test do
  use ExUnit.Case
  doctest Aoc.Day6

  test "Part 1" do
    input = Aoc.Day6.input_part1("priv/day6/input.txt")
    assert Aoc.Day6.part1(input) == 5_784_380_717_354
  end

  @tag timeout: :infinity
  test "Part 2" do
    input = Aoc.Day6.input_part2("priv/day6/input.txt")
    assert Aoc.Day6.part2(input) == 7_996_218_225_744
  end
end
