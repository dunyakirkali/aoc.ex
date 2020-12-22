defmodule Day22Test do
  use ExUnit.Case
  doctest Aoc.Day22

  test "Part 1" do
    inp = Aoc.Day22.input("priv/day22/input.txt")
    assert Aoc.Day22.part1(inp) == 30197
  end

  test "Part 2" do
    inp = Aoc.Day22.input("priv/day22/input.txt")
    assert Aoc.Day22.part2(inp) == 34031
  end
end
