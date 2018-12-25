defmodule Day21Test do
  use ExUnit.Case
  doctest Day21
  
  test "Part 1" do
    # assert Day21.part_1("priv/input.txt", [0, 0, 0, 0, 0, 0]) == 2040
    assert Day21.part_1("priv/input.txt", [0, 0, 255, 1526130, 18, 65536]) == 2040
  end
  
  # test "Part 2" do
  #   assert Day21.part_2("priv/input.txt") == 25165632
  # end
end
