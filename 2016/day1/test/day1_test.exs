defmodule Day1Test do
  use ExUnit.Case
  doctest Day1
  
  test "from north rotate right" do
    state = %{ direction: :north, position: {0, 0} }
    rotation = "R"
    %{ direction: direction } = Day1.rotate(state, rotation)
    assert direction == :east
  end
  
  test "from north rotate left" do
    state = %{ direction: :north, position: {0, 0} }
    rotation = "L"
    %{ direction: direction } = Day1.rotate(state, rotation)
    assert direction == :west
  end
  
  test "from east rotate right" do
    state = %{ direction: :east, position: {0, 0} }
    rotation = "R"
    %{ direction: direction } = Day1.rotate(state, rotation)
    assert direction == :south
  end
  
  test "from east rotate left" do
    state = %{ direction: :east, position: {0, 0} }
    rotation = "L"
    %{ direction: direction } = Day1.rotate(state, rotation)
    assert direction == :north
  end
  
  test "from south rotate right" do
    state = %{ direction: :south, position: {0, 0} }
    rotation = "R"
    %{ direction: direction } = Day1.rotate(state, rotation)
    assert direction == :west
  end
  
  test "from south rotate left" do
    state = %{ direction: :south, position: {0, 0} }
    rotation = "L"
    %{ direction: direction } = Day1.rotate(state, rotation)
    assert direction == :east
  end

  test "from west rotate right" do
    state = %{ direction: :west, position: {0, 0} }
    rotation = "R"
    %{ direction: direction } = Day1.rotate(state, rotation)
    assert direction == :north
  end
  
  test "from west rotate left" do
    state = %{ direction: :west, position: {0, 0} }
    rotation = "L"
    %{ direction: direction } = Day1.rotate(state, rotation)
    assert direction == :south
  end
  
  test "move west by 5" do
    state = %{ direction: :west, position: {0, 0} }
    %{ position: position } = Day1.move(state, 5)
    assert position == {-5, 0}
  end
  
  test "move north by 3" do
    state = %{ direction: :north, position: {0, 0} }
    %{ position: position } = Day1.move(state, 3)
    assert position == {0, -3}
  end
  
  test "move south by 2" do
    state = %{ direction: :south, position: {0, 0} }
    %{ position: position } = Day1.move(state, 2)
    assert position == {0, 2}
  end
  
  test "move east by 6" do
    state = %{ direction: :east, position: {0, 0} }
    %{ position: position } = Day1.move(state, 6)
    assert position == {6, 0}
  end
  
  test "distance" do
    state = %{ position: {3, 4} }
    assert Day1.distance(state) == 7
  end
  
  test "step" do
    state = %{ direction: :east, position: {0, 0} }
    assert Day1.step([], state) == state
  end
  
  test "sample 1" do
    assert Day1.solve("R2, L3") == 5
  end
  
  test "sample 2" do
    assert Day1.solve("R2, R2, R2") == 2
  end
  
  test "sample 3" do
    assert Day1.solve("R5, L5, R5, R3") == 12
  end
  
  test "solution" do
    assert Day1.solve("L3, R2, L5, R1, L1, L2, L2, R1, R5, R1, L1, L2, R2, R4, L4, L3, L3, R5, L1, R3, L5, L2, R4, L5, R4, R2, L2, L1, R1, L3, L3, R2, R1, L4, L1, L1, R4, R5, R1, L2, L1, R188, R4, L3, R54, L4, R4, R74, R2, L4, R185, R1, R3, R5, L2, L3, R1, L1, L3, R3, R2, L3, L4, R1, L3, L5, L2, R2, L1, R2, R1, L4, R5, R4, L5, L5, L4, R5, R4, L5, L3, R4, R1, L5, L4, L3, R5, L5, L2, L4, R4, R4, R2, L1, L3, L2, R5, R4, L5, R1, R2, R5, L2, R4, R5, L2, L3, R3, L4, R3, L2, R1, R4, L5, R1, L5, L3, R4, L2, L2, L5, L5, R5, R2, L5, R1, L3, L2, L2, R3, L3, L4, R2, R3, L1, R2, L5, L3, R4, L4, R4, R3, L3, R1, L3, R5, L5, R1, R5, R3, L1") == 209
  end
end
