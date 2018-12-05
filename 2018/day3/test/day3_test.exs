defmodule Day3Test do
  use ExUnit.Case
  doctest Day3

  test "Part 1" do
    input =
      'input.txt'
      |> File.read!()
      |> String.trim()
      |> String.split("\n")

    assert length(Day3.overlapping(input)) == 118_223
  end
end
