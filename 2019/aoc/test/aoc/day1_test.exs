defmodule Day1Test do
  use ExUnit.Case
  doctest Aoc.Day1

  test "greets the world" do
    assert Aoc.Day1.run() == :world
  end
end
