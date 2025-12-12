defmodule Day12 do
  use ExUnit.Case
  doctest Aoc.Day12

  @tag timeout: :infinity
  test "Part 1" do
    input = Aoc.Day12.input("priv/day12/input.txt")
    assert Aoc.Day12.part1(input) == 454
  end

  # @tag timeout: :infinity
  # test "Part 2" do
  #   input = Aoc.Day12.input("priv/day12/input.txt")
  #   assert Aoc.Day12.part2(input) == 462444153119850
  # end
end
