defmodule Day21Test do
  use ExUnit.Case
  doctest Aoc.Day21

  test "Part 1" do
    input = Aoc.Day21.input("priv/day21/input.txt")
    assert Aoc.Day21.part1(input, 64) == 3820
  end

  test "Part 2" do
    input = Aoc.Day21.input("priv/day21/input.txt")
    assert Aoc.Day21.part2(input, 26_501_365) == 632_421_652_138_917
  end
end
