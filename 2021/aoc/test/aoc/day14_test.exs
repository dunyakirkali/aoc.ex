defmodule Day14Test do
  use ExUnit.Case
  doctest Aoc.Day14

  test "Part 1" do
    input = Aoc.Day14.input("priv/day14/input.txt")
    assert Aoc.Day14.part1(input) == 2768
  end

  test "Part 2" do
    input = Aoc.Day14.input("priv/day14/input.txt")
    assert Aoc.Day14.part2(input) == 2914365137499
  end
end
