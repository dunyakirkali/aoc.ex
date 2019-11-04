defmodule Day10Test do
  use ExUnit.Case
  # doctest Day10

  test "part 1" do
    input = 'priv/input.txt' |> File.read! |> String.split("\n", trim: true)

    assert Day10.part_1(input, {17, 61}) == 86
  end
end
