defmodule Day15Test do
  use ExUnit.Case
  doctest Aoc.Day15

  @tag timeout: :infinity
  test "Part 1" do
    assert Aoc.Day15.part1() == 272
  end

  test "Part 2" do
    assert Aoc.Day15.part2() == 398
  end
end
