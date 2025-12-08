defmodule Day8Test do
  use ExUnit.Case
  doctest Aoc.Day8

  @tag timeout: :infinity
  test "Part 1" do
    input = Aoc.Day8.input("priv/day8/input.txt")
    assert Aoc.Day8.part1(input, 1000) == 90036
  end

  @tag timeout: :infinity
  test "Part 2" do
    input = Aoc.Day8.input("priv/day8/input.txt")
    assert Aoc.Day8.part2(input) == 6_083_499_488
  end
end
