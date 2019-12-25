defmodule AocYear2017Day1Test do
  use ExUnit.Case
  doctest Aoc.Year2017.Day1

  test "Part 1" do
    assert Aoc.Year2017.Day1.part1("priv/2017/day1/input.txt") == 1393
  end

  test "Part 2" do
    assert Aoc.Year2017.Day1.part2("priv/2017/day1/input.txt") == 1292
  end

  # test "String.to_integer vs Integer.digits" do
  #   Aoc.Year2017.Day1.bench
  # end
end
