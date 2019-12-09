defmodule Day9Test do
  use ExUnit.Case
  doctest Aoc.Day9

  test "RBO-1" do
    "priv/day9/example_4.txt"
    |> AGC.new()
    |> Map.put(:relative_base_offset, 2000)
    |> AGC.run()
    |> Map.get(:relative_base_offset)
    |> Kernel.==(2019)
    |> assert
  end

  test "RBO-2" do
    "priv/day9/example_5.txt"
    |> AGC.new()
    |> Map.put(:relative_base_offset, 2000)
    |> AGC.run()
    |> Map.get(:output)
    |> Enum.at(0)
    |> Kernel.==(12)
    |> assert
  end

  test "Part 1" do
    "priv/day9/input.txt"
    |> AGC.new()
    |> Map.put(:inputs, [1])
    |> AGC.run()
    |> Map.get(:output)
    |> Enum.at(0)
    |> Kernel.==(4006117640)
    |> assert()
  end

  test "Part 2" do
    "priv/day9/input.txt"
    |> AGC.new()
    |> Map.put(:inputs, [2])
    |> AGC.run()
    |> Map.get(:output)
    |> Enum.at(0)
    |> Kernel.==(88231)
    |> assert()
  end
end
