defmodule Day2Test do
  use ExUnit.Case
  doctest Aoc.Day2

  test "Part 1" do
    res =
      Aoc.Day2.input
      |> List.replace_at(1, 12)
      |> List.replace_at(2, 2)
      |> Aoc.Day2.part1()
    assert Enum.at(res, 0) == 3562624
  end

  test "Part 2" do
    assert Aoc.Day2.part2(19690720) == 8298
  end
end
