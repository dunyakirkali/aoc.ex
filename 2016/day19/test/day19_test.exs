defmodule Day19Test do
  use ExUnit.Case
  doctest Day19

  test "Part 1" do
    assert Day19.part_1(3014603) == 1834903
  end

  test "Part 1 shortcut" do
    assert Day19.part_1_shortcurt(3014603) == 1834903
  end
end
