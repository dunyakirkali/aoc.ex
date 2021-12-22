defmodule Day22Test do
  use ExUnit.Case
  doctest Aoc.Day22

  test "Part 1" do
    input = Aoc.Day22.input("priv/day22/input.txt")
    assert Aoc.Day22.part1(input) == 568_000
  end

  test "Part 2" do
    input = Aoc.Day22.input("priv/day22/input.txt")
    assert Aoc.Day22.part2(input) == 1_177_411_289_280_259
  end
end
