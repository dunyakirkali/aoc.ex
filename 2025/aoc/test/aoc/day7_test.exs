defmodule Day7Test do
  use ExUnit.Case
  doctest Aoc.Day7

  @tag timeout: :infinity
  test "Part 1" do
    input = Aoc.Day7.input("priv/day7/input.txt")
    assert Aoc.Day7.part1(input) == 1613
  end

  @tag timeout: :infinity
  test "Part 2" do
    input = Aoc.Day7.input("priv/day7/input.txt")
    assert Aoc.Day7.part2(input) == 48_021_610_271_997
  end
end
