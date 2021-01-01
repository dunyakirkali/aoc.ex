defmodule Day4Test do
  use ExUnit.Case
  doctest Aoc.Day4

  test "Part 1" do
    assert Aoc.Day4.part1() == 1653
  end

  @tag timeout: :infinity
  test "Part 2" do
    assert Aoc.Day4.part2() == 1133
  end
end
