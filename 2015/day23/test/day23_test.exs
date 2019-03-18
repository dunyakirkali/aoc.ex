defmodule Day23Test do
  use ExUnit.Case
  doctest Day23
  
  test "Part 1" do
    commands =
      "priv/input.txt"
      |> File.read!()
      |> String.split("\n", trim: true)
    assert Day23.part_1(commands) == 307
  end
  
  test "Part 2" do
    commands =
      "priv/input.txt"
      |> File.read!()
      |> String.split("\n", trim: true)
    assert Day23.part_2(commands) == 160
  end
end
