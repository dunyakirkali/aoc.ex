defmodule Day12Test do
  use ExUnit.Case
  doctest Day12

  test "Part 1" do
    assert Day12.part_1("priv/input.txt") == 318_117
  end
  
  test "Part 2" do
    assert Day12.part_2("priv/input.txt") == 9_227_771
  end
end
