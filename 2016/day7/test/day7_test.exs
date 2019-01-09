defmodule Day7Test do
  use ExUnit.Case
  doctest Day7
  
  test "Part 1" do
    input =
      'priv/input.txt'
      |> File.read!()
      |> String.split("\n", trim: true)

    assert Day7.part_1(input) == 110
  end
  
  test "Part 2" do
    input =
      'priv/input.txt'
      |> File.read!()
      |> String.split("\n", trim: true)

    assert Day7.part_2(input) == 242
  end
end
