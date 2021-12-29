defmodule Day23Test do
  use ExUnit.Case
  doctest Aoc.Day23

  test "Part 1" do
    start_state = Aoc.Day23.input("priv/day23/input.txt")
    end_state = Aoc.Day23.input("priv/day23/final1.txt")
    assert Aoc.Day23.part1(start_state, end_state) == 14546
  end

  test "Part 2" do
    start_state = Aoc.Day23.input("priv/day23/input2.txt")
    end_state = Aoc.Day23.input("priv/day23/final2.txt")
    assert Aoc.Day23.part2(start_state, end_state) == 42308
  end
end
