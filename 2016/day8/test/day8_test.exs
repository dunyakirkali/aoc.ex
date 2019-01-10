defmodule Day8Test do
  use ExUnit.Case
  # doctest Day8
  
  test "Part 1" do
    input =
      'priv/input.txt'
      |> File.read!()
      |> String.split("\n", trim: true)

    assert Day8.part_1(input, {50, 6}) == 119
  end
end
