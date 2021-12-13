defmodule Day16Test do
  use ExUnit.Case
  doctest Aoc.Day16

  @tag timeout: :infinity
  test "Part 1" do
    assert Aoc.Day16.part1("priv/day16/input.txt") == 40921727
  end

  @tag timeout: :infinity
  test "Part 2" do
    assert Aoc.Day16.part2("priv/day16/input.txt") == 89950138
  end
end
