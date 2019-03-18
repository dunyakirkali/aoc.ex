defmodule Day24Test do
  use ExUnit.Case
  doctest Day24

  test "Part 1" do
    packages =
      "priv/input.txt"
      |> File.read!
      |> String.split("\n", trim: true)
      |> Enum.map(fn x -> String.to_integer(x) end)
  
    assert Day24.part_1(packages) == 10723906903
  end
  
  test "Part 2" do
    packages =
      "priv/input.txt"
      |> File.read!
      |> String.split("\n", trim: true)
      |> Enum.map(fn x -> String.to_integer(x) end)
  
    assert Day24.part_2(packages) == 74850409
  end
end
