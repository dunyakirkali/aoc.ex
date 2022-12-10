defmodule Day10Test do
  use ExUnit.Case
  doctest Aoc.Day10

  test "Part 1" do
    input = Aoc.Day10.input("priv/day10/input.txt")
    assert Aoc.Day10.part1(input) == 13920
  end

  test "Part 2" do
    input = Aoc.Day10.input("priv/day10/input.txt")
    assert Aoc.Day10.part2(input) == :ok
  end
end
