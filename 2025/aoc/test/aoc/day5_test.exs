defmodule Day5Test do
  use ExUnit.Case
  doctest Aoc.Day5

  test "Part 1" do
    input = Aoc.Day5.input("priv/day5/input.txt")
    assert Aoc.Day5.part1(input) == 775
  end

  @tag timeout: :infinity
  test "Part 2" do
    input = Aoc.Day5.input("priv/day5/input.txt")
    assert Aoc.Day5.part2(input) == 350_684_792_662_845
  end
end
