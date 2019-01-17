defmodule Day9Test do
  use ExUnit.Case
  doctest Day9
  
  test "Part 1" do
    input =
      'priv/input.txt'
      |> File.read!()
  
    assert Day9.part_1(input) == 102_239
  end
  
  test "Part 2" do
    input =
      'priv/input.txt'
      |> File.read!()
  
    assert Day9.part_2(input) == 10_780_403_063
  end
end
