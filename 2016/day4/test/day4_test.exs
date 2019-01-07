defmodule Day4Test do
  use ExUnit.Case
  doctest Day4

  test "Part 1" do
    input =
      'priv/input.txt'
      |> File.read!()
      |> String.split("\n", trim: true)

    assert Day4.part_1(input) == 137_896
  end
  
  test "Part 2" do
    input =
      'priv/input.txt'
      |> File.read!()
      |> String.split("\n", trim: true)

    assert Day4.part_2(input) == 501
  end
end
