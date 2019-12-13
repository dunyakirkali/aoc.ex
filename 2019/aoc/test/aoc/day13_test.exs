defmodule Day13Test do
  use ExUnit.Case
  doctest Aoc.Day13

  test "Part 1" do
    assert Aoc.Day13.part1() == 216
  end

  @tag timeout: :infinity
  test "Part 2" do
    assert Aoc.Day13.part2() == 10025
  end
end
