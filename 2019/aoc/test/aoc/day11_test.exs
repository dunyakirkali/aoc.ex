defmodule Day11Test do
  use ExUnit.Case
  doctest Aoc.Day11

  test "Part 1" do
    map = for x <- 0..1000, y <- 0..1000, do: {x, y}
    map = Enum.reduce(map, Map.new, fn point, acc ->
      Map.put(acc, point, :black)
    end)
    assert Aoc.Day11.part1(map) == 2511
  end

  test "Part 2" do
    map = for x <- 0..1000, y <- 0..1000, do: {x, y}
    map = Enum.reduce(map, Map.new, fn point, acc ->
      Map.put(acc, point, :black)
    end)
    map = Map.put(map, {500, 500}, :white)
    assert Aoc.Day11.part1(map) == 248
  end
end
