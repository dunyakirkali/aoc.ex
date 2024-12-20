defmodule Day20Test do
  use ExUnit.Case
  doctest Aoc.Day20

  test "Part 1" do
    input = Aoc.Day20.input("priv/day20/input.txt")
    assert Aoc.Day20.part1(input) == 1317
  end

  test "Part 2" do
    input = Aoc.Day20.input("priv/day20/input.txt")
    assert Aoc.Day20.part2(input) == 982_474
  end
end
