defmodule Day18Test do
  use ExUnit.Case
  doctest Day18

  test "Part 1" do
    assert Day18.part_1(".^^^.^.^^^.^.......^^.^^^^.^^^^..^^^^^.^.^^^..^^.^.^^..^.^..^^...^.^^.^^^...^^.^.^^^..^^^^.....^....", 40) == 2013
  end
end
