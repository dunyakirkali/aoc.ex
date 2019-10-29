defmodule Day17Test do
  use ExUnit.Case
  doctest Day17

  test "Part 1" do
    assert Day17.part_1("udskfozm", {1, 1}) == "DDRLRRUDDR"
  end
end
