defmodule Day2Test do
  use ExUnit.Case
  doctest Aoc.Day2

  test "Part 1" do
    input = Aoc.Day2.input()
    assert Aoc.Day2.part1(input) == 1586300
  end

  test "Part 2" do
    input = Aoc.Day2.input()
    assert Aoc.Day2.part2(input) == 3737498
  end
end
