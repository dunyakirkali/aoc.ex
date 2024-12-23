defmodule Day23Test do
  use ExUnit.Case
  doctest Aoc.Day23

  test "Part 1" do
    input = Aoc.Day23.input("priv/day23/input.txt")
    assert Aoc.Day23.part1(input) == 1200
  end

  test "Part 2" do
    input = Aoc.Day23.input("priv/day23/input.txt")
    assert Aoc.Day23.part2(input) == "ag,gh,hh,iv,jx,nq,oc,qm,rb,sm,vm,wu,zr"
  end
end
