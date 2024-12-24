defmodule Day24Test do
  use ExUnit.Case
  doctest Aoc.Day24

  test "Part 1" do
    input = Aoc.Day24.input("priv/day24/input.txt")
    assert Aoc.Day24.part1(input) == 66055249060558
  end

  # test "Part 2" do
  #   input = Aoc.Day24.input("priv/day24/input.txt")
  #   assert Aoc.Day24.part2(input) == "ag,gh,hh,iv,jx,nq,oc,qm,rb,sm,vm,wu,zr"
  # end
end
