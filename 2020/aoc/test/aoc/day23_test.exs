defmodule Day23Test do
  use ExUnit.Case
  doctest Aoc.Day23

  test "Part 1" do
    assert Aoc.Day23.part1("538914762") == "54327968"
  end

  test "Part 2" do
    assert Aoc.Day23.part2("538914762") == 157410423276
  end
end
