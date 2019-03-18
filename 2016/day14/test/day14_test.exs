defmodule Day14Test do
  use ExUnit.Case
  doctest Day14

  test "Part 1" do
    assert Day14.part_1("ahsbgdzn") == 23890
  end
  
  test "Part 2" do
    assert Day14.part_2("ahsbgdzn") == 22696
  end
end
