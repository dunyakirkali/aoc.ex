defmodule Day10Test do
  use ExUnit.Case
  doctest Aoc.Day10

  @tag timeout: :infinity
  test "Part 1" do
    input = Aoc.Day10.input("priv/day10/input.txt")
    assert Aoc.Day10.part1(input) == 404
  end

  @tag timeout: :infinity
  test "Part 2" do
    input = Aoc.Day10.input("priv/day10/input.txt")
    assert Aoc.Day10.part2(input) == 16474
  end
end
