defmodule Day21Test do
  use ExUnit.Case
  doctest Aoc.Day21

  test "Part 1" do
    inp = Aoc.Day21.input("priv/day21/input.txt")
    assert Aoc.Day21.part1(inp) == 2170
  end

  test "Part 2" do
    inp = Aoc.Day21.input("priv/day21/input.txt")
    assert Aoc.Day21.part2(inp) == "nfnfk,nbgklf,clvr,fttbhdr,qjxxpr,hdsm,sjhds,xchzh"
  end
end
