defmodule Day25Test do
  use ExUnit.Case
  doctest Day25

  test "Example 1" do
    input = """
    0,0,0,0
    3,0,0,0
    0,3,0,0
    0,0,3,0
    0,0,0,3
    0,0,0,6
    9,0,0,0
    12,0,0,0
    """
    assert Day25.number_of_constellations(input) == 2
  end
  
  test "Example 1a" do
    input = """
    0,0,0,0
    3,0,0,0
    0,3,0,0
    0,0,3,0
    0,0,0,3
    0,0,0,6
    9,0,0,0
    12,0,0,0
    6,0,0,0
    """
    assert Day25.number_of_constellations(input) == 1
  end
  
  
  # test "Example 2" do
  #   input = """
  #   -1,2,2,0
  #   0,0,2,-2
  #   0,0,0,-2
  #   -1,2,0,0
  #   -2,-2,-2,2
  #   3,0,2,-1
  #   -1,3,2,2
  #   -1,0,-1,0
  #   0,2,1,-2
  #   3,0,0,0
  #   """
  #   assert Day25.number_of_constellations(input) == 4
  # end
  
  test "Example 3" do
    input = """
    1,-1,0,1
    2,0,-1,0
    3,2,-1,0
    0,0,3,1
    0,0,-1,-1
    2,3,-2,0
    -2,2,0,0
    2,-2,0,-1
    1,-1,0,-1
    3,2,0,2
    """
    assert Day25.number_of_constellations(input) == 3
  end
  
  # test "Example 4" do
  #   input = """
  #   1,-1,-1,-2
  #   -2,-2,0,1
  #   0,2,1,3
  #   -2,3,-2,1
  #   0,2,3,-2
  #   -1,-1,1,-2
  #   0,-2,-1,0
  #   -2,2,3,-1
  #   1,2,2,0
  #   -1,-2,0,-2
  #   """
  #   assert Day25.number_of_constellations(input) == 8
  # end
  # 
  # test "Part 1" do
  #   input = "priv/input.txt" |> File.read!()
  #   assert Day25.number_of_constellations(input) == 8
  # end
end
