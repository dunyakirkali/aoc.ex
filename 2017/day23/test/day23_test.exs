defmodule Day23Test do
  use ExUnit.Case
  doctest Day23

  test "Part 1" do
    input = 
      "priv/input.txt"
      |> File.read!()
      |> String.split("\n", trim: true)

    assert Day23.part_1(input) == 6724
  end
  
  test "Part 2" do
    assert Day23.part_2() == 903
  end
end
