defmodule Day18Test do
  use ExUnit.Case
  doctest Aoc.Day18

  @tag timeout: :infinity
  test "Part 1 - Example 1" do
    assert Aoc.Day18.part1("priv/day18/example_1.txt") == 8
  end

  @tag timeout: :infinity
  test "Part 1 - Example 2" do
    assert Aoc.Day18.part1("priv/day18/example_2.txt") == 86
  end

  @tag timeout: :infinity
  test "Part 1 - Example 3" do
    assert Aoc.Day18.part1("priv/day18/example_3.txt") == 132
  end

  @tag timeout: :infinity
  test "Part 1 - Example 4" do
    assert Aoc.Day18.part1("priv/day18/example_4.txt") == 136
  end

  @tag timeout: :infinity
  test "Part 1 - Example 5" do
    assert Aoc.Day18.part1("priv/day18/example_5.txt") == 81
  end

  @tag timeout: :infinity
  test "Part 1" do
    assert Aoc.Day18.part1("priv/day18/input.txt") == 3646
  end

  @tag timeout: :infinity
  test "Part 2" do
    assert Aoc.Day18.part2("priv/day18/input_2.txt") == 1730
  end
end
