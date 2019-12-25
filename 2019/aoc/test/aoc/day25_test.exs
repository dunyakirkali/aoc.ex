defmodule Day25Test do
  use ExUnit.Case
  doctest Aoc.Day25

  @tag timeout: :infinity
  test "Part 1" do
    assert Aoc.Day25.part1() == -1
  end

  # @tag timeout: :infinity
  # test "Part 2" do
  #   assert Aoc.Day25.part2("priv/day25/input.txt") == -1
  # end
end
