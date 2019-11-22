defmodule Day13Test do
  use ExUnit.Case
  doctest Day13

  test "Part 1" do
    assert Day13.part_1(1350, {31, 39}) == 92
  end

  test "Part 2" do
    assert Day13.part_2(1350) == 124
  end
end
