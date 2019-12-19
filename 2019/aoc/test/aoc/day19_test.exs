
defmodule Day19Test do
  use ExUnit.Case
  doctest Aoc.Day19

  test "Part 1" do
    assert Aoc.Day19.part1() == 181
  end

  @tag timeout: :infinity
  test "Part 2" do
    assert Aoc.Day19.part2() == 4240964
  end
end
