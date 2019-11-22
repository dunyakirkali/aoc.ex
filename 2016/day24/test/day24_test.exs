defmodule Day24Test do
  use ExUnit.Case
  doctest Day24

  @tag timeout: :infinity
  test "Part 1" do
    assert Day24.part_1("priv/input.txt") == 430
  end

  @tag timeout: :infinity
  test "Part 2" do
    assert Day24.part_2("priv/input.txt") == 700
  end
end
