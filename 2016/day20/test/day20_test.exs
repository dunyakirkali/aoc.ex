defmodule Day20Test do
  use ExUnit.Case
  doctest Day20

  test "Part 1" do
    assert Day20.part_1("priv/input.txt") == :world
  end
end
