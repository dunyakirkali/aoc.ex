defmodule Day1Test do
  use ExUnit.Case
  doctest Aoc.Day1

  test "Part 1" do
    input = Aoc.Day1.input()
    assert Aoc.Day1.part1(input) == 876_459
  end

  test "Part 2" do
    input = Aoc.Day1.input()
    assert Aoc.Day1.part2(input) == 116_168_640
  end
end
