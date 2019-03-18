defmodule Day15Test do
  use ExUnit.Case
  doctest Day15

  test "Part 1" do
    assert Day15.part_1("priv/input.txt") == 400589
  end
  
  test "Part 2" do
    assert Day15.part_2("priv/input.txt") == 3045959
  end
end
