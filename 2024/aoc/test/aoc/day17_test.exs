defmodule Day17Test do
  use ExUnit.Case
  doctest Aoc.Day17

  test "Part 1" do
    input = Aoc.Day17.input("priv/day17/input.txt")

    assert Aoc.Day17.part1(input) ==
             {%{"A" => 0, "B" => 6, "C" => 3}, 16, [6, 0, 6, 3, 0, 2, 3, 1, 6]}
  end

  test "Part 2" do
    input = Aoc.Day17.input("priv/day17/input.txt")
    assert Aoc.Day17.part2(input) == 498
  end
end
