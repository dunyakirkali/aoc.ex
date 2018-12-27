defmodule Day22Test do
  use ExUnit.Case
  doctest Day22
  
  test "part_1" do
    # Day22.print_game(11394, {7, 701})
    assert Day22.risk(11394, {7, 701}) == 5637
  end
  
  test "part_2" do
    assert Day22.part_2(11394, {7, 701}) == 969
  end
end
