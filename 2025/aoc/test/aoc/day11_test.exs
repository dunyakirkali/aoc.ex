defmodule Day11 do
  use ExUnit.Case
  doctest Aoc.Day11

  @tag timeout: :infinity
  test "Part 1" do
    input = Aoc.Day11.input("priv/day11/input.txt")
    assert Aoc.Day11.part1(input) == 764
  end

  @tag timeout: :infinity
  test "Part 2" do
    input = Aoc.Day11.input("priv/day11/input.txt")
    assert Aoc.Day11.part2(input) == 462444153119850
  end
end
