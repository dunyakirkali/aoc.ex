defmodule Day8Test do
  use ExUnit.Case
  doctest Aoc.Day8

  @tag timeout: :infinity
  test "Part 2" do
    assert Aoc.Day8.part2("priv/day8/input.txt", {25, 6}) == :ok
  end
end
