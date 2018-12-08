defmodule Day1Test do
  use ExUnit.Case
  doctest Day1

  test "follow" do
    input =
      'priv/input.txt'
      |> File.read!()
      |> String.split(", ", trim: true)

    assert Day1.follow(input) == 209
  end
end
