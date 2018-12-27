defmodule Day25Test do
  use ExUnit.Case
  doctest Day25

  test "Part 1" do
    filename = "priv/input.txt"
    assert Day25.part_1(filename) == 394
  end
end
