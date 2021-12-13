defmodule AocYear2017Day2Test do
  use ExUnit.Case
  doctest Aoc.Year2017.Day2

  test "Part 1" do
    assert Aoc.Year2017.Day2.part1("priv/2017/day2/input.txt") == 36174
  end

  test "Part 2" do
    assert Aoc.Year2017.Day2.part2("priv/2017/day2/input.txt") == 244
  end
end
