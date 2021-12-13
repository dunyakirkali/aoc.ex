defmodule Day13Test do
  use ExUnit.Case
  doctest Aoc.Day13

  test "Part 1" do
    input = Aoc.Day13.input("priv/day13/input.txt")
    assert Aoc.Day13.part1(input) == 678
  end

  test "Part 2" do
    input = Aoc.Day13.input("priv/day13/input.txt")
    assert Aoc.Day13.part2(input) == :ok
  end
end
