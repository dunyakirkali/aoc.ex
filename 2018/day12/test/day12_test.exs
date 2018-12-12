defmodule Day12Test do
  use ExUnit.Case
  doctest Day12

  test "initial_state for example" do
    assert Day12.initial_state("priv/example.txt") == "#..#.#..##......###...###"
  end

  test "initial_state for input" do
    assert Day12.initial_state("priv/input.txt") == "..##.#######...##.###...#..#.#.#..#.##.#.##....####..........#..#.######..####.#.#..###.##..##..#..#"
  end

  test "iterate 0 step for example" do
    filename = "priv/example.txt"
    string = Day12.initial_state(filename)
    string = String.pad_leading(string, String.length(string) + 20, ".")
    string = String.pad_trailing(string, String.length(string) + 20, ".")
    assert Day12.iterate(filename, string, 0) == "....................#..#.#..##......###...###...................."
  end

  test "iterate 1 step for example" do
    filename = "priv/example.txt"
    string = Day12.initial_state(filename)
    string = String.pad_leading(string, String.length(string) + 20, ".")
    string = String.pad_trailing(string, String.length(string) + 20, ".")
    assert Day12.iterate(filename, string, 1) == "....................#...#....#.....#..#..#..#...................."
  end

  test "iterate 20 step for example" do
    filename = "priv/example.txt"
    string = Day12.initial_state(filename)
    string = String.pad_leading(string, String.length(string) + 20, ".")
    string = String.pad_trailing(string, String.length(string) + 20, ".")
    res = Day12.iterate(filename, string, 20)
    assert res == "..................#....##....#####...#######....#.#..##.........."

    sum =
      res
      |> String.split("")
      |> Enum.with_index(-21)
      |> Enum.reduce(0, fn {char, val}, acc ->
        if char == "#", do: acc + val, else: acc
      end)
    assert sum == 325
  end

  test "iterate 20 step for input" do
    filename = "priv/input.txt"
    pad = 100
    string = Day12.initial_state(filename)
    string = String.pad_leading(string, String.length(string) + pad, ".")
    string = String.pad_trailing(string, String.length(string) + pad, ".")
    res = Day12.iterate(filename, string, 20)
    # assert res == ".................#.#..##..##..##..####..#.....#.###.#......##..#....##..#......##..##..###.#......#.#..#.#.......##..#....##..##..#....#...."

    sum =
      res
      |> String.split("")
      |> Enum.with_index((pad + 1) * -1)
      |> Enum.reduce(0, fn {char, val}, acc ->
        if char == "#", do: acc + val, else: acc
      end)
    assert sum == 2542
  end

  test "iterate 50000000000 step for input" do
    filename = "priv/input.txt"
    pad = 100_000
    string = Day12.initial_state(filename)
    string = String.pad_leading(string, String.length(string) + pad, ".")
    string = String.pad_trailing(string, String.length(string) + pad, ".")
    res = Day12.iterate(filename, string, 50_000_000_000)
    # assert res == ".................#.#..##..##..##..####..#.....#.###.#......##..#....##..#......##..##..###.#......#.#..#.#.......##..#....##..##..#....#...."

    sum =
      res
      |> String.split("")
      |> Enum.with_index((pad + 1) * -1)
      |> Enum.reduce(0, fn {char, val}, acc ->
        if char == "#", do: acc + val, else: acc
      end)
    assert sum == 2542
  end
end
