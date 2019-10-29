defmodule Day20Test do
  use ExUnit.Case
  doctest Day20

  @tag timeout: :infinity
  test "Part 1" do
    assert Day20.part_1_shortcut("priv/input.txt") == 17348574
  end
end
