defmodule Day7Test do
  use ExUnit.Case
  doctest Aoc.Day7

  @tag timeout: :infinity
  test "Part 1" do
    assert Aoc.Day7.part1("priv/day7/input.txt") == 51679
  end

  @tag timeout: :infinity
  test "Part 2 Example 4" do
    assert Aoc.Day7.part2("priv/day7/example_4.txt") == 139629729
  end

  @tag timeout: :infinity
  test "Part 2 Example 5" do
    assert Aoc.Day7.part2("priv/day7/example_5.txt") == 18216
  end

  @tag timeout: :infinity
  test "Part 2" do
    assert Aoc.Day7.part2("priv/day7/input.txt") == 19539216
  end
end
