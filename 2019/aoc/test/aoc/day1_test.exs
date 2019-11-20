defmodule Day1Test do
  use ExUnit.Case
  doctest Aoc.Day1

  test "Part 1" do
    assert Aoc.Day1.part1() == "prr\n"
  end

  test "Part 2" do
    assert Aoc.Day1.part2() == "B"
  end
end
