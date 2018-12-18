defmodule Day18Test do
  use ExUnit.Case
  doctest Day18
  
  test "Part 1 Example" do
    assert Day18.part_1("priv/example.txt") == 1147
  end
  
  test "Part 1" do
    assert Day18.part_1("priv/input.txt") == 584714
  end
  
  test "Part 2" do
    assert Day18.part_2("priv/input.txt", 1_000_000_000) == 161160
  end
end
