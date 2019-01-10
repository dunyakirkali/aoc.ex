defmodule Day8 do
  @moduledoc """
  Documentation for Day8.
  """
  
  @doc """
      iex> Day8.part_1([
      ...>   "rect 3x2",
      ...>   "rotate column x=1 by 1",
      ...>   "rotate row y=0 by 4",
      ...>   "rotate column x=1 by 1"
      ...> ], {7, 3})
      6
  """
  def part_1(steps, {width, height}) do
    map =
      0..(width - 1)
      |> Enum.reduce(%{}, fn x, acc ->
        0..(height - 1)
        |> Enum.reduce(acc, fn y, acc ->
          Map.put(acc, {x, y}, ".")
        end)
      end)
    
    steps
    |> Enum.reduce(map, fn step, acc ->
      acc =
        cond do
          Regex.match?(~r/rect (\d+)x(\d+)/, step) ->
            captures = Regex.named_captures(~r/rect (?<width>\d+)x(?<height>\d+)/, step)
            rect(acc, {String.to_integer(captures["width"]), String.to_integer(captures["height"])})
          Regex.match?(~r/rotate row y=(\d+) by (\d+)/, step) ->
            captures = Regex.named_captures(~r/rotate row y=(?<row>\d+) by (?<rotation>\d+)/, step)
            rotate_row(acc, String.to_integer(captures["row"]), String.to_integer(captures["rotation"]))
          Regex.match?(~r/rotate column x=(\d+) by (\d+)/, step) ->
            captures = Regex.named_captures(~r/rotate column x=(?<col>\d+) by (?<rotation>\d+)/, step)
            rotate_column(acc, String.to_integer(captures["col"]), String.to_integer(captures["rotation"]))
        end

      IEx.Helpers.clear
      IO.puts(step)
      print(acc)
      Process.sleep(100)
      acc
    end)
    |> Enum.filter(fn {_, v} ->
      v == "#"
    end)
    |> Enum.count
  end

  @doc """
      iex> Day8.rotate_row(%{
      ...>   {0, 0} => "#",
      ...>   {1, 0} => ".",
      ...>   {2, 0} => "#",
      ...>   {3, 0} => ".",
      ...>   {4, 0} => ".",
      ...>   {5, 0} => ".",
      ...>   {6, 0} => ".",
      ...>   {0, 1} => "#",
      ...>   {1, 1} => "#",
      ...>   {2, 1} => "#",
      ...>   {3, 1} => ".",
      ...>   {4, 1} => ".",
      ...>   {5, 1} => ".",
      ...>   {6, 1} => ".",
      ...>   {0, 2} => ".",
      ...>   {1, 2} => "#",
      ...>   {2, 2} => ".",
      ...>   {3, 2} => ".",
      ...>   {4, 2} => ".",
      ...>   {5, 2} => ".",
      ...>   {6, 2} => ".",
      ...> }, 0, 4)
      %{
        {0, 0} => ".",
        {1, 0} => ".",
        {2, 0} => ".",
        {3, 0} => ".",
        {4, 0} => "#",
        {5, 0} => ".",
        {6, 0} => "#",
        {0, 1} => "#",
        {1, 1} => "#",
        {2, 1} => "#",
        {3, 1} => ".",
        {4, 1} => ".",
        {5, 1} => ".",
        {6, 1} => ".",
        {0, 2} => ".",
        {1, 2} => "#",
        {2, 2} => ".",
        {3, 2} => ".",
        {4, 2} => ".",
        {5, 2} => ".",
        {6, 2} => ".",
      }
  """
  def rotate_row(map, row, rotation) do
    IO.puts("Rotate by #{rotation}")
    map
    |> row(row)
    |> right_rotate(rotation)
    |> Enum.with_index
    |> Enum.reduce(map, fn {item, col}, acc ->
      Map.put(acc, {col, row}, item)
    end)
  end
    
  @doc """
      iex> Day8.rotate_column(%{
      ...>   {0, 0} => "#",
      ...>   {1, 0} => "#",
      ...>   {2, 0} => "#",
      ...>   {3, 0} => ".",
      ...>   {4, 0} => ".",
      ...>   {5, 0} => ".",
      ...>   {6, 0} => ".",
      ...>   {0, 1} => "#",
      ...>   {1, 1} => "#",
      ...>   {2, 1} => "#",
      ...>   {3, 1} => ".",
      ...>   {4, 1} => ".",
      ...>   {5, 1} => ".",
      ...>   {6, 1} => ".",
      ...>   {0, 2} => ".",
      ...>   {1, 2} => ".",
      ...>   {2, 2} => ".",
      ...>   {3, 2} => ".",
      ...>   {4, 2} => ".",
      ...>   {5, 2} => ".",
      ...>   {6, 2} => ".",
      ...> }, 1, 1)
      %{
        {0, 0} => "#",
        {1, 0} => ".",
        {2, 0} => "#",
        {3, 0} => ".",
        {4, 0} => ".",
        {5, 0} => ".",
        {6, 0} => ".",
        {0, 1} => "#",
        {1, 1} => "#",
        {2, 1} => "#",
        {3, 1} => ".",
        {4, 1} => ".",
        {5, 1} => ".",
        {6, 1} => ".",
        {0, 2} => ".",
        {1, 2} => "#",
        {2, 2} => ".",
        {3, 2} => ".",
        {4, 2} => ".",
        {5, 2} => ".",
        {6, 2} => ".",
      }
  """
  def rotate_column(map, col, rotation) do
    map
    |> column(col)
    |> right_rotate(rotation)
    |> Enum.with_index
    |> Enum.reduce(map, fn {item, row}, acc ->
      Map.put(acc, {col, row}, item)
    end)
  end
  
  @doc """
      iex> Day8.rect(%{
      ...>   {0, 0} => ".",
      ...>   {1, 0} => ".",
      ...>   {2, 0} => ".",
      ...>   {3, 0} => ".",
      ...>   {4, 0} => ".",
      ...>   {5, 0} => ".",
      ...>   {6, 0} => ".",
      ...>   {0, 1} => ".",
      ...>   {1, 1} => ".",
      ...>   {2, 1} => ".",
      ...>   {3, 1} => ".",
      ...>   {4, 1} => ".",
      ...>   {5, 1} => ".",
      ...>   {6, 1} => ".",
      ...>   {0, 2} => ".",
      ...>   {1, 2} => ".",
      ...>   {2, 2} => ".",
      ...>   {3, 2} => ".",
      ...>   {4, 2} => ".",
      ...>   {5, 2} => ".",
      ...>   {6, 2} => ".",
      ...> }, {3, 2})
      %{
        {0, 0} => "#",
        {1, 0} => "#",
        {2, 0} => "#",
        {3, 0} => ".",
        {4, 0} => ".",
        {5, 0} => ".",
        {6, 0} => ".",
        {0, 1} => "#",
        {1, 1} => "#",
        {2, 1} => "#",
        {3, 1} => ".",
        {4, 1} => ".",
        {5, 1} => ".",
        {6, 1} => ".",
        {0, 2} => ".",
        {1, 2} => ".",
        {2, 2} => ".",
        {3, 2} => ".",
        {4, 2} => ".",
        {5, 2} => ".",
        {6, 2} => ".",
      }
  """
  def rect(map, {width, height}) do
    Enum.reduce(0..(width - 1), map, fn x, map ->
      Enum.reduce(0..(height - 1), map, fn y, map ->
        Map.put(map, {x, y}, "#")
      end)
    end)
  end
  
  @doc """
      iex> Day8.column(%{
      ...>   {0, 0} => "#",
      ...>   {1, 0} => "#",
      ...>   {2, 0} => "#",
      ...>   {3, 0} => ".",
      ...>   {4, 0} => ".",
      ...>   {5, 0} => ".",
      ...>   {6, 0} => ".",
      ...>   {0, 1} => "#",
      ...>   {1, 1} => "#",
      ...>   {2, 1} => "#",
      ...>   {3, 1} => ".",
      ...>   {4, 1} => ".",
      ...>   {5, 1} => ".",
      ...>   {6, 1} => ".",
      ...>   {0, 2} => ".",
      ...>   {1, 2} => ".",
      ...>   {2, 2} => ".",
      ...>   {3, 2} => ".",
      ...>   {4, 2} => ".",
      ...>   {5, 2} => ".",
      ...>   {6, 2} => ".",
      ...> }, 1)
      ["#", "#", "."]
  """
  def column(map, col) do
    map
    |> Enum.filter(fn {k, _} ->
      elem(k, 0) == col
    end)
    |> Enum.sort_by(fn {k, _} ->
      elem(k, 1)
    end)
    |> Enum.map(fn {_, v} ->
      v
    end)
  end
  
  @doc """
      iex> Day8.row(%{
      ...>   {0, 0} => "#",
      ...>   {1, 0} => ".",
      ...>   {2, 0} => "#",
      ...>   {3, 0} => ".",
      ...>   {4, 0} => ".",
      ...>   {5, 0} => ".",
      ...>   {6, 0} => ".",
      ...>   {0, 1} => "#",
      ...>   {1, 1} => "#",
      ...>   {2, 1} => "#",
      ...>   {3, 1} => ".",
      ...>   {4, 1} => ".",
      ...>   {5, 1} => ".",
      ...>   {6, 1} => ".",
      ...>   {0, 2} => ".",
      ...>   {1, 2} => "#",
      ...>   {2, 2} => ".",
      ...>   {3, 2} => ".",
      ...>   {4, 2} => ".",
      ...>   {5, 2} => ".",
      ...>   {6, 2} => ".",
      ...> }, 0)
      ["#", ".", "#", ".", ".", ".", "."]
  """
  def row(map, row) do
    map
    |> Enum.filter(fn {k, _} ->
      elem(k, 1) == row
    end)
    |> Enum.sort_by(fn {k, _} ->
      elem(k, 0)
    end)
    |> Enum.map(fn {_, v} ->
      v
    end)
  end
  
  @doc """
      iex> Day8.size(%{{0, 0} => ".", {1, 0} => ".", {0, 1} => ".", {1, 1} => "."})
      {2, 2}
  """
  def size(map) do
    map
    |> Map.keys
    |> Enum.reduce({0, 0}, fn {x, y}, {maxX, maxY} ->
      {max(x, maxX), max(y, maxY)}
    end)
    |> Tuple.to_list
    |> Enum.map(&(&1 + 1))
    |> List.to_tuple
  end
  
  def print(map) do
    size = size(map)
    
    Enum.each(0..(elem(size, 1)), fn y ->
      Enum.map(0..(elem(size, 0)), fn x ->
        map[{x, y}]
      end)
      |> Enum.join("")
      |> IO.puts()
    end)
    
    map
  end

  @doc """
      iex> Day8.left_rotate(["#", ".", "#", ".", ".", "."], 4)
      [".", ".", "#", ".", "#", "."]
  """
  def left_rotate(l, n \\ 1)
  def left_rotate([], _), do: []
  def left_rotate(l, 0), do: l
  def left_rotate([h | t], 1), do: t ++ [h]
  def left_rotate(l, n) when n > 0, do: left_rotate(left_rotate(l, 1), n-1)
  def left_rotate(l, n), do: right_rotate(l, -n)

  @doc """
      iex> Day8.right_rotate(["#", ".", "#", ".", ".", ".", "."], 4)
      [".", ".", ".", ".", "#", ".", "#"]
      
      iex> Day8.right_rotate(["#", ".", ".", ".", ".", ".", "."], 5)
      [".", ".", ".", ".", ".", "#", "."]
  """
  def right_rotate(l, n \\ 1)
  def right_rotate(l, n) when n > 0, do: Enum.reverse(l) |> left_rotate(n) |> Enum.reverse
  def right_rotate(l, n), do: left_rotate(l, -n)
end
