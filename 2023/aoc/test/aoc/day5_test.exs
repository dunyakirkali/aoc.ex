defmodule Day5Test do
  use ExUnit.Case
  doctest Aoc.Day5

  # test "Part 1" do
  #   input = Aoc.Day5.input("priv/day5/input.txt")
  #   assert Aoc.Day5.part1(input) == 331_445_006
  # end

  test "Part 2" do
    input = "priv/day5/input.txt"
    assert Aoc.Day5.part2(input) == 6_472_060
  end
end
