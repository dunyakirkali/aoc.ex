defmodule Day12Test do
  use ExUnit.Case
  doctest Aoc.Day12

  test "Part 1" do
    assert Aoc.Day12.part1("priv/day12/input.txt", 1000) == 14809
  end

  @tag timeout: :infinity
  test "Part 2 - Example 1" do
    assert Aoc.Day12.part2("priv/day12/example_1.txt") == 2772
  end

  @tag timeout: :infinity
  test "Part 2 - Example 2" do
    assert Aoc.Day12.part2("priv/day12/example_2.txt") == 4_686_774_924
  end

  @tag timeout: :infinity
  test "Part 2" do
    assert Aoc.Day12.part2("priv/day12/input.txt") == 282270365571288
  end
end
