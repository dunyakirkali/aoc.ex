defmodule Day21Test do
  use ExUnit.Case
  doctest Aoc.Day21

  test "Part 1" do
    assert Aoc.Day21.part1({{7, 0}, {6, 0}, 0}) == 671_580
  end

  test "Part 2" do
    assert Aoc.Day21.part2({{7, 0}, {6, 0}}) == 912_857_726_749_764
  end
end
