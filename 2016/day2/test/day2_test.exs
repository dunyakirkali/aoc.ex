defmodule Day2Test do
  use ExUnit.Case
  doctest Day2
  
  test "Part 1" do
    input =
      'priv/input.txt'
      |> File.read!()
      |> String.split("\n", trim: true)
  
    assert Day2.part_1(input) == 78985
  end

  # test "Part 2" do
  #   input =
  #     'priv/input.txt'
  #     |> File.read!()
  #     |> String.split(", ", trim: true)
  # 
  #   assert Day1.part_2(input) == 136
  # end
end
