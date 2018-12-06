defmodule Day6Test do
  use ExUnit.Case
  doctest Day6

  test "part_1" do
    input = 'input.txt' |> File.read!()

    assert Day6.part_1(input) == 4771
  end

  test "part_2" do
    input = 'input.txt' |> File.read!()

    assert Day6.part_2(input, 10000) == 39149
  end

  test "total_distance" do
    anchors = [
      {1, 1},
      {1, 6},
      {8, 3},
      {3, 4},
      {5, 5},
      {8, 9}
    ]
    point = {4, 3}
    assert Day6.total_distance(anchors, point) == 30
  end

  test "get_maxes" do
    input = %{
      {0, 0} => 0,
      {0, 1} => 1,
      {1, 0} => 2,
      {1, 1} => 0
    }

    assert Day6.get_maxes(input) == %{
      0 => 2,
      1 => 1,
      2 => 1
    }
  end

  test "get_infinites" do
    input = %{
      {0, 0} => 0,
      {0, 1} => 1,
      {0, 2} => 2,
      {1, 0} => 2,
      {1, 1} => 3,
      {1, 2} => 0,
      {2, 0} => 0,
      {2, 1} => 1,
      {2, 2} => 2
    }
    size = {2, 2}

    assert Day6.get_infinites(input, size) == [0, 1, 2]
  end

  test "get_max_count" do
    input = %{
      0 => 5,
      1 => 10,
      2 => 10,
      3 => 11
    }
    infinites = [0, 1]
    assert Day6.get_max_count(input, infinites) == 11
  end

  test "get_coords" do
    input = """
    1, 1
    1, 6
    8, 3
    3, 4
    5, 5
    8, 9
    """

    assert Day6.get_coords(input) |> length == input |> String.split("\n", trim: true) |> length
  end

  test "man_dist" do
    a = {9, 5}
    b = {5, 2}

    assert Day6.man_dist(a, b) == 7
  end

  test "find_closes_anchor" do
    anchors = [
      {1, 1},
      {1, 6},
      {8, 3},
      {3, 4},
      {5, 5},
      {8, 9}
    ]
    assert Day6.find_closes_anchor({0, 0}, anchors) == 0
    assert Day6.find_closes_anchor({1, 1}, anchors) == 0
    assert Day6.find_closes_anchor({1, 6}, anchors) == 1
  end

  test "field_size" do
    input = [
      {1, 1},
      {1, 6},
      {8, 3},
      {3, 4},
      {5, 5},
      {8, 9}
    ]

    assert Day6.field_size(input) == {8, 9}
  end

  test "part_1 example_1" do
    input = """
    1, 1
    1, 6
    8, 3
    3, 4
    5, 5
    8, 9
    """

    assert Day6.part_1(input) == 17
  end

  test "part_2 example_1" do
    input = """
    1, 1
    1, 6
    8, 3
    3, 4
    5, 5
    8, 9
    """

    assert Day6.part_2(input, 32) == 16
  end
end
