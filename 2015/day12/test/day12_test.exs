defmodule Day12Test do
  use ExUnit.Case
  doctest Day12

  test "Part 2" do
    json_string = File.read!("priv/input.txt")
    assert Day12.part_2(json_string) == 96852
  end
end
