defmodule Day11Test do
  use ExUnit.Case
  doctest Aoc.Day11

  test "Part 1" do
    input = Aoc.Day11.input("priv/day11/input.txt")
    assert Aoc.Day11.part1(input) == 9_639_160
  end

  test "Part 2" do
    input = Aoc.Day11.input("priv/day11/input.txt")
    assert Aoc.Day11.part2(input, 1_000_000) == 752_936_133_304
  end
end
