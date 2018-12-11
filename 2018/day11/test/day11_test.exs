defmodule Day11Test do
  use ExUnit.Case
  doctest Day11

  test "Coordinate of the top-left fuel cell of the 3x3 square with the largest total power" do
    assert Day11.part_1(4151) == %{coords: {20, 46}, power: 30}
  end

  test "Coordinate of the top-left fuel cell of any size square with the largest total power" do
    assert Day11.part_2(4151) == %{coords: {231, 65}, power: 158}
  end
end
