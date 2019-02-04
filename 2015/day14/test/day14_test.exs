defmodule Day14Test do
  use ExUnit.Case
  doctest Day14

  test "Part 2" do
    lines =
      "priv/input.txt"
      |> File.read!
      |> String.split("\n", trim: true)
    assert Day14.part_2(lines, 2503) == 1084
  end
end
