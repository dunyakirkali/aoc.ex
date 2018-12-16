defmodule Day15Test do
  use ExUnit.Case
  doctest Day15
  
  test "part_1" do
    assert Day15.part_1("priv/input.txt") == 198744
  end 
  
  test "part_2" do
    assert Day15.part_2("priv/input.txt") == 66510
  end
end
