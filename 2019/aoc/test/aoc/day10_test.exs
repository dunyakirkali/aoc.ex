defmodule Day10Test do
  use ExUnit.Case
  doctest Aoc.Day10

  test "Part 1" do
    assert Aoc.Day10.part1() == 309
  end

  test "Part 2" do
    assert Aoc.Day10.part2("priv/day10/input.txt", {37,25}) == 416
  end
end
