defmodule Day16Test do
  use ExUnit.Case
  doctest Day16

  test "Part 1" do
    assert Day16.part_1("10001110011110000") == "10010101010011101"
  end
  
  test "Part 2" do
    assert Day16.part_2("10001110011110000") == "01100111101101111"
  end
end
