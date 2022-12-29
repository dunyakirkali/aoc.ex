defmodule Day24Test do
  use ExUnit.Case
  doctest Aoc.Day24

  test "Part 1" do
    input = Aoc.Day24.input("priv/day24/input.txt")
    assert Aoc.Day24.part1(input) == 245
  end

  # test "Part 2" do
  #   input = Aoc.Day24.input("priv/day24/input.txt")
  #   assert Aoc.Day24.part2(input) == 798
  # end
end
