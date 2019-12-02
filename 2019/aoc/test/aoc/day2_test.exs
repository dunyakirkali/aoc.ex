defmodule Day2Test do
  use ExUnit.Case
  doctest Aoc.Day2

  test "Part 1" do
    assert Aoc.Day2.part1() == 3562624
  end

  test "Part 2" do
    assert Aoc.Day2.part2(19690720) == 8298
  end
end
