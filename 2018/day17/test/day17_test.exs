defmodule Day17Test do
  use ExUnit.Case
  doctest Day17

  test "Part 1 example" do
    assert Day17.part_1("priv/example.txt") == 57
  end
  
  test "Part 1" do
    assert Day17.part_1("priv/input.txt") == 26910
  end
  
  test "Part 2 example" do
    assert Day17.part_2("priv/example.txt") == 29
  end
  
  test "Part 2" do
    assert Day17.part_2("priv/input.txt") == 22182
  end
end
