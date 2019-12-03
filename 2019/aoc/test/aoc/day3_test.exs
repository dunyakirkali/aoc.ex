defmodule Day3Test do
  use ExUnit.Case
  doctest Aoc.Day3

  test "Part 1" do
    assert Aoc.Day3.part1("priv/day3/input.txt") == 860
  end

  @tag timeout: :infinity
  test "Part 2" do
    assert Aoc.Day3.part2("priv/day3/input.txt") == 9238
  end
end
