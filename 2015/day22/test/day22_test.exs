defmodule Day22Test do
  use ExUnit.Case
  doctest Day22

  # test "Part 1" do
    # assert Day22.part_1(%{hp: 50, mana: 500}, %{hp: 58, damage: 9}) == 1269
  # end
  
  test "Part 2" do
    assert Day22.part_2(%{hp: 50, mana: 500}, %{hp: 58, damage: 9}) == 0
  end
end
