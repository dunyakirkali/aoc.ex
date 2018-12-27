defmodule Day25 do
  use Memoize
  @moduledoc """
  Documentation for Day25.
  """
  
  def part_1(input) do
    input
    |> groups()
    |> Enum.count()
  end
  
  defp groups(input) do
    points(input)
    |> Stream.unfold(&pop_group/1)
    |> Stream.take_while(&(not is_nil(&1)))
  end
  
  defp pop_group([]), do: nil
  defp pop_group([point | rest]), do: pop_group_of(point, rest)

  defp pop_group_of(point, points), do: pop_group_of(point, [point], points)

  defp pop_group_of(point, group_acc, points) do
    {neighbours, rest} = Enum.split_with(points, &(man_dist(&1, point) <= 3))

    Enum.reduce(
      neighbours,
      {group_acc, rest},
      fn neighbour, {group_acc, rest} -> pop_group_of(neighbour, [neighbour | group_acc], rest) end
    )
  end
  
  defmemo points(filename) do
    filename
    |> File.stream!()
    |> Stream.map(&String.trim/1)
    |> Stream.map(&String.split(&1, ","))
    |> Enum.map(&parse_point/1)
  end
  
  def parse_point(coordinates) do
    coordinates
    |> Enum.map(&String.to_integer/1)
    |> List.to_tuple()
  end

  @doc """
      iex> Day25.man_dist({0,0,0,0}, {3,0,0,0})
      3
      
      iex> Day25.man_dist({0,4,5,0}, {3,0,0,6})
      18
      
      iex> Day25.man_dist({1,-1,0,1}, {2,0,-1,0})
      4
  """
  defmemo man_dist({x1, y1, z1, t1}, {x2, y2, z2, t2}) do
    abs(x1 - x2) +
    abs(y1 - y2) +
    abs(z1 - z2) +
    abs(t1 - t2)
  end
end
