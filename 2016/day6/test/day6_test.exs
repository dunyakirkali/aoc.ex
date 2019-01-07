defmodule Day6Test do
  use ExUnit.Case
  doctest Day6
  
  test "Part 1" do
    input =
      'priv/input.txt'
      |> File.read!()
      |> String.split("\n", trim: true)

    assert Day6.part_1(input) == "tzstqsua"
  end
  
  test "Part 2" do
    input =
      'priv/input.txt'
      |> File.read!()
      |> String.split("\n", trim: true)

    assert Day6.part_2(input) == "myregdnr"
  end
end
