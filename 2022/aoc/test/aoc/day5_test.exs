defmodule Day5Test do
  use ExUnit.Case
  doctest Aoc.Day5

  test "Part 1" do
    input = Aoc.Day5.input()
    assert Aoc.Day5.part1(input) == "HBTMTBSDC"
  end

  test "Part 2" do
    input = Aoc.Day5.input()
    assert Aoc.Day5.part2(input) == "PQTJRSHWS"
  end
end
