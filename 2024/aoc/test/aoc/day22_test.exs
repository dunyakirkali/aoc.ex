defmodule Day22Test do
  use ExUnit.Case
  doctest Aoc.Day22

  test "Part 1" do
    input = Aoc.Day22.input("priv/day22/input.txt")
    assert Aoc.Day22.part1(input) == 19_822_877_190
  end

  test "Part 2" do
    input = Aoc.Day22.input("priv/day22/input.txt")
    assert Aoc.Day22.part2(input) == 2277
  end
end
