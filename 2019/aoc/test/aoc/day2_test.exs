defmodule Day2Test do
  use ExUnit.Case
  doctest Aoc.Day2

  test "Part 1" do
    Aoc.Day2.part1()
    |> Map.get(:instructions)
    |> Enum.at(0)
    |> Kernel.==(3562624)
    |> assert
  end

  test "Part 2" do
    Aoc.Day2.part2(19690720)
    |> Kernel.==(8298)
    |> assert
  end
end
