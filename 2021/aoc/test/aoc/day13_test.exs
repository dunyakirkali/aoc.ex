defmodule Day13Test do
  use ExUnit.Case
  doctest Aoc.Day13

  import ExUnit.CaptureIO

  test "Part 1" do
    input = Aoc.Day13.input("priv/day13/input.txt")
    assert Aoc.Day13.part1(input) == 678
  end

  test "Part 2" do
    expected_output = """

    ####..##..####.#..#.#....#..#.####.####
    #....#..#.#....#..#.#....#..#....#.#...
    ###..#....###..####.#....####...#..###.
    #....#....#....#..#.#....#..#..#...#...
    #....#..#.#....#..#.#....#..#.#....#...
    ####..##..#....#..#.####.#..#.####.#...
    """

    input = Aoc.Day13.input("priv/day13/input.txt")

    assert capture_io(fn ->
             Aoc.Day13.part2(input)
           end) == expected_output
  end
end
