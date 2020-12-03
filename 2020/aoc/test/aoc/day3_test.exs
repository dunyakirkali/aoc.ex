defmodule Day3Test do
  use ExUnit.Case
  doctest Aoc.Day3

  test "Part 1" do
    chart = Aoc.Chart.new("priv/day3/input.txt")
    assert Aoc.Day3.part1(chart, {3, 1}) == 151
  end

  test "Part 2" do
    chart = Aoc.Chart.new("priv/day3/input.txt")
    assert Aoc.Day3.part2(chart) == 7_540_141_059
  end
end
