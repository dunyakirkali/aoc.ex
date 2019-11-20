defmodule Day25Test do
  use ExUnit.Case
  doctest Day25

  @tag timeout: :infinity
  test "Part 1" do
    assert Day25.part_1("priv/input.txt") == 189
  end
end
