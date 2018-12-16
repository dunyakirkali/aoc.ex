defmodule Day15Test do
  use ExUnit.Case
  doctest Day15

  test "round example 3" do
    map = Day15.parse_map("priv/example_3.txt")
    assert Day15.round(map) == 27730
  end
  
  test "round example 2" do
    map = Day15.parse_map("priv/example_2.txt")
    assert Day15.round(map) == 10132
  end
  
  test "parse_map" do
    assert Day15.parse_map("priv/example_1.txt") == %{
      {0, 0} => "#",
      {1, 0} => "#",
      {2, 0} => "#",
      {3, 0} => "#",
      {4, 0} => "#",
      {5, 0} => "#",
      {6, 0} => "#",
      
      {0, 1} => "#",
      {1, 1} => ".",
      {2, 1} => {"G", 200},
      {3, 1} => ".",
      {4, 1} => {"E", 200},
      {5, 1} => ".",
      {6, 1} => "#",
      
      {0, 2} => "#",
      {1, 2} => {"E", 200},
      {2, 2} => ".",
      {3, 2} => {"G", 200},
      {4, 2} => ".",
      {5, 2} => {"E", 200},
      {6, 2} => "#",
      
      {0, 3} => "#",
      {1, 3} => ".",
      {2, 3} => {"G", 200},
      {3, 3} => ".",
      {4, 3} => {"E", 200},
      {5, 3} => ".",
      {6, 3} => "#",
      
      {0, 4} => "#",
      {1, 4} => "#",
      {2, 4} => "#",
      {3, 4} => "#",
      {4, 4} => "#",
      {5, 4} => "#",
      {6, 4} => "#",
    }
  end
end
