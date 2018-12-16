defmodule Day14Test do
  use ExUnit.Case
  doctest Day14

  test "Part 1" do
    assert Day14.part_1(409551) == "1631191756"
  end
  
  test "Part 2" do
    assert Day14.part_2(409551) == 20219475
  end
end
