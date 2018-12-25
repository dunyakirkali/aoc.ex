defmodule Day23 do
  import NimbleParsec
  
  use Memoize
  
  def part_2(filename) do
    positions = read(filename)
    minMaxX = 
      positions
      |> minMax("x")
      |> Enum.to_list
      |> IO.inspect
    minMaxY = 
      positions
      |> minMax("y")
      |> Enum.to_list
      |> IO.inspect
    minMaxZ = 
      positions
      |> minMax("z")
      |> Enum.to_list
      |> IO.inspect
    
    Enum.reduce(minMaxX, %{}, fn x, acc ->
      Enum.reduce(minMaxY, acc, fn y, acc ->
        Enum.reduce(minMaxZ, acc, fn z, acc ->
          count = 
            Enum.reduce(positions, 0, fn position, counter ->
              to = %{"x" => Integer.to_string(x), "y" => Integer.to_string(y), "z" => Integer.to_string(z)} |> IO.inspect(label: "aa")
              
              if String.to_integer(position["r"]) >= man_dist(to, position) do
                counter + 1
              else
                counter
              end
            end)
          Map.put(acc, {x, y, z}, count)
        end)
      end)
    end)
    |> Enum.max_by(fn {k, v} ->
      v
    end)
    |> elem(0)
    |> Tuple.to_list()
    |> Enum.sum()
  end
  
  def minMax(positions, indir) do
    minX =
      positions
      |> Enum.map(fn position ->
        position[indir]
      end)
      |> Enum.sort
      |> List.first
      |> String.to_integer
      
    maxX =
      positions
      |> Enum.map(fn position ->
        position[indir]
      end)
      |> Enum.sort
      |> Enum.reverse
      |> List.first
      |> String.to_integer
    minX..maxX
  end
  
  def part_1(filename) do
    largest = largest(filename)
    
    read(filename)
    |> Enum.filter(fn position ->
      String.to_integer(largest["r"]) >= man_dist(largest, position)
    end)
    |> Enum.count
  end
  
  defmemo largest(filename) do
    filename
    |> read()
    |> Enum.sort_by(fn position -> position["r"] end)
    |> List.last()
    |> IO.inspect()
  end
  
  defmemo read(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      Regex.named_captures(~r/pos=<(?<x>.*),(?<y>.*),(?<z>.*)>, r=(?<r>.*)/, line)
    end)
  end
  
  defmemo man_dist(a, b) do
    abs(String.to_integer(a["x"]) - String.to_integer(b["x"])) + abs(String.to_integer(a["y"]) - String.to_integer(b["y"])) + abs(String.to_integer(a["z"]) - String.to_integer(b["z"]))
  end
end
