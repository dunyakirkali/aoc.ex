defmodule Day3Test do
  use ExUnit.Case
  doctest Day3

  test "Part 1" do
    input =
      'priv/input.txt'
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split(" ", trim: true)
        |> Enum.map(&String.to_integer/1)
        |> List.to_tuple()
      end)
  
    assert Day3.part_1(input) == 982
  end
  
  test "Part 2" do
    input =
      'priv/input.txt'
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.chunk_every(3)
      |> Enum.map(fn group ->
        parsed = 
          group
          |> Enum.map(fn line ->
            line
            |> String.split(" ", trim: true)
            |> Enum.map(&String.to_integer/1)
          end)
        row_1 = Enum.at(parsed, 0)
        row_2 = Enum.at(parsed, 1)
        row_3 = Enum.at(parsed, 2)
        
        [
          {Enum.at(row_1, 0), Enum.at(row_2, 0), Enum.at(row_3, 0)},
          {Enum.at(row_1, 1), Enum.at(row_2, 1), Enum.at(row_3, 1)},
          {Enum.at(row_1, 2), Enum.at(row_2, 2), Enum.at(row_3, 2)}
        ]
      end)
      |> List.flatten()
      
    assert Day3.part_1(input) == 1826
  end
end
