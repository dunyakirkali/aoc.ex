defmodule Day6Test do
  use ExUnit.Case
  doctest Day6

  test "part_1" do
    input = 'input.txt' |> File.read!

    assert Day6.part_1(input) == :world
  end

  test "part_2" do
    input = 'input.txt' |> File.read!

    assert Day6.part_2(input) == :world
  end
end
