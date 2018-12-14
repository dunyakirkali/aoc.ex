defmodule Day13Test do
  use ExUnit.Case
  doctest Day13

  test "Part 1 - Example 1" do
    assert Day13.part_1("priv/example_1.txt") == {0, 3}
  end
  
  test "Part 1 - Example 2" do
    assert Day13.part_1("priv/example_2.txt") == {7, 3}
  end
  
  test "Part 1" do
    assert Day13.part_1("priv/input.txt") == {14, 42}
  end
  
  # test "Part 2 - Example 1" do
  #   assert Day13.part_2("priv/example_3.txt") == {6, 4}
  # end
  # 
  # test "Part 2" do
  #   assert Day13.part_2("priv/input.txt") == {8, 7}
  # end
end
