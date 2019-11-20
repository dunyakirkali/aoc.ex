defmodule Day23Test do
  use ExUnit.Case
  doctest Day23

  test "Part 1" do
    assert Day23.part_1("priv/input.txt") == 13776
  end
end
