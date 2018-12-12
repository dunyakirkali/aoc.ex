defmodule Day12Test do
  use ExUnit.Case
  doctest Day12

  test "iterate 0 step for example" do
    filename = "priv/example.txt"
    string = Day12.initial_state(filename)
    assert Day12.iterate(filename, string, 0, 0) == {".....#..#.#..##......###...###.....", 5}
  end

  test "iterate 1 step for example" do
    filename = "priv/example.txt"
    string = Day12.initial_state(filename)
    assert Day12.iterate(filename, string, 1, 0) == {".....#...#....#.....#..#..#..#.....", 5}
  end

  test "iterate 2 step for example" do
    filename = "priv/example.txt"
    string = Day12.initial_state(filename)
    assert Day12.iterate(filename, string, 2, 0) == {".....##..##...##....#..#..#..##.....", 5}
  end

  test "iterate 3 step for example" do
    filename = "priv/example.txt"
    string = Day12.initial_state(filename)
    assert Day12.iterate(filename, string, 3, 0) == {".....#.#...#..#.#....#..#..#...#.....", 6}
  end

  test "iterate 20 step for example" do
    filename = "priv/example.txt"
    string = Day12.initial_state(filename)
    res = Day12.iterate(filename, string, 20, 0)

    assert res == {".....#....##....#####...#######....#.#..##.....", 7}
    assert Day12.sum(res) == 325
  end

  test "iterate 20 step for input" do
    filename = "priv/input.txt"
    string = Day12.initial_state(filename)
    res = Day12.iterate(filename, string, 20, 0)

    assert Day12.sum(res) == 2542
  end

  test "iterate 50000000000 step for input" do
    filename = "priv/input.txt"
    string = Day12.initial_state(filename)

    assert Day12.part_2(filename, string) == 2_550_000_000_883
  end
end
