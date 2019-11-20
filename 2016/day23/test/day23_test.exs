defmodule Day23Test do
  use ExUnit.Case
  doctest Day23

  test "Part 1" do
    assert Day23.part_1("priv/input.txt", 7) == 13776
  end

  test "Part 2" do
    assert Day23.part_2("priv/input.txt", 12) == 479010336
  end
end
