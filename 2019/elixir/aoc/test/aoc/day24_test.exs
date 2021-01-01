
defmodule Day24Test do
  use ExUnit.Case
  doctest Aoc.Day24

  @tag timeout: :infinity
  test "Part 1" do
    assert Aoc.Day24.part1("priv/day24/input.txt") == 18350099
  end

  @tag timeout: :infinity
  test "Part 2" do
    assert Aoc.Day24.part2("priv/day24/input.txt", 200) == 2037
  end
end
