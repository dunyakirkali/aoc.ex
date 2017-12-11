defmodule Day11 do
  def direction(str) do
    case str do
      "ne" -> {+1, 0, -1}
      "se" -> {+1, -1, 0}
      "s"  -> {0, -1, +1}
      "sw" -> {-1, 0, +1}
      "nw" -> {-1, +1, 0}
      "n"  -> {0, +1, -1}
    end
  end

  def parse_string(str) do
    String.trim(str)
    |> String.split(",")
  end

  def add_coord({x,y,z}, {x2,y2,z2}), do: {x+x2, y+y2, z+z2}

  def get_coord(str) do
    parse_string(str)
    |> Enum.map(&direction/1)
    |> Enum.reduce({0,0,0}, &add_coord/2)
  end

  def distance(inp) when is_bitstring inp do
    get_coord(inp)
    |> distance
  end

  def distance(inp) when is_tuple inp do
    Tuple.to_list(inp)
    |> Enum.map(&abs/1)
    |> Enum.max
  end

  def farthest(str) do
    parse_string(str)
    |> Enum.map(&direction/1)
    |> Enum.map_reduce({0,0,0}, fn x, acc ->
      {add_coord(x,acc), add_coord(x,acc)}end)
    |> Tuple.to_list
    |> Enum.take(1)
    |> List.flatten
    |> Enum.map(&distance/1)
    |> Enum.max
  end
end

inp = File.read!("spec/day11/steps")

Day11.distance(inp)
|> IO.inspect

Day11.farthest(inp)
|> IO.inspect
