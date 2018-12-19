defmodule Day19Test do
  use ExUnit.Case
  doctest Day19
  
  test "Part 1 Example" do
    assert Day19.part_1("priv/example.txt") == 6
  end
  
  test "Part 1" do
    assert Day19.part_1("priv/input.txt") == 2040
  end
  
  test "Part 2" do
    assert Day19.part_2("priv/input.txt") == 25165632
  end
end
