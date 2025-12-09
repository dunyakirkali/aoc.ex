defmodule Day9Test do
  use ExUnit.Case
  doctest Aoc.Day9

  @tag timeout: :infinity
  test "Part 1" do
    input = Aoc.Day9.input("priv/day9/input.txt")
    assert Aoc.Day9.part1(input) == 4_764_078_684
  end

  @tag timeout: :infinity
  test "Part 2" do
    input = Aoc.Day9.input("priv/day9/input.txt")
    assert Aoc.Day9.part2(input) == 1_652_344_888
  end
end
