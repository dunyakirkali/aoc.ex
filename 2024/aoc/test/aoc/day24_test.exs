defmodule Day24Test do
  use ExUnit.Case
  doctest Aoc.Day24

  test "Part 1" do
    input = Aoc.Day24.input("priv/day24/input.txt")
    assert Aoc.Day24.part1(input) == 66_055_249_060_558
  end

  test "Part 2" do
    input = Aoc.Day24.input("priv/day24/input.txt")
    assert Aoc.Day24.part2(input) == "fcd,fhp,hmk,rvf,tpc,z16,z20,z33"
  end
end
