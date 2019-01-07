defmodule Day5Test do
  use ExUnit.Case
  doctest Day5

  test "Part 1" do
    assert Day5.part_1("abbhdwsy") == "801b56a7"
  end
  
  test "Part 2" do
    assert Day5.part_2("abbhdwsy") == "424a0197"
  end
end
