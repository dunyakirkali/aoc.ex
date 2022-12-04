defmodule Day4Test do
  use ExUnit.Case
  doctest Aoc.Day4

  test "Part 1" do
    input = Aoc.Day4.input()
    assert Aoc.Day4.part1(input) == 483
  end

  test "Part 2" do
    input = Aoc.Day4.input()
    assert Aoc.Day4.part2(input) == 874
  end
end
