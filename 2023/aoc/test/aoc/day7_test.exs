defmodule Day7Test do
  use ExUnit.Case
  doctest Aoc.Day7
  doctest Aoc.Day7.HandWithBid
  doctest Aoc.Day7.Card

  test "Part 1" do
    input = Aoc.Day7.input("priv/day7/input.txt")
    assert Aoc.Day7.part1(input) == 253_313_241
  end

  test "Part 2" do
    input = Aoc.Day7.input("priv/day7/input.txt")
    assert Aoc.Day7.part2(input) == 253_362_743
  end
end
