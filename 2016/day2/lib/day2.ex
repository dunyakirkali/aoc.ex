defmodule Day2 do
  @moduledoc """
  Documentation for Day2.
  """

  @doc """
      iex> Day2.part_2([
      ...>   "ULL",
      ...>   "RRDDD",
      ...>   "LURDL",
      ...>   "UUUUD"
      ...> ])
      "5DB3"
  """  
  def part_2(lines) do
    lines
    |> Enum.reduce({[], {0, 2}}, fn line, {acc, pos} ->
      pos = 
        line
        |> String.split("", trim: true)
        |> Enum.reduce(pos, fn item, pos ->
          move_2(pos, item)
        end)
      {[key(pos, 1) | acc], pos}
    end)
    |> elem(0)
    |> Enum.reverse()
    |> Enum.join()
  end

  @doc """
      iex> Day2.part_1([
      ...>   "ULL",
      ...>   "RRDDD",
      ...>   "LURDL",
      ...>   "UUUUD"
      ...> ])
      "1985"
  """
  def part_1(lines) do
    lines
    |> Enum.reduce({[], {1, 1}}, fn line, {acc, pos} ->
      pos = 
        line
        |> String.split("", trim: true)
        |> Enum.reduce(pos, fn item, pos ->
          move(pos, item)
        end)
      {[key(pos, 0) | acc], pos}
    end)
    |> elem(0)
    |> Enum.reverse()
    |> Enum.join()
  end
  
  @doc """
      iex> Day2.key({1, 1}, 0)
      5
      
      iex> Day2.key({2, 2}, 0)
      9
  """
  def key(pos, type) when type == 0 do
    case pos do
      {0, 0} -> 1
      {1, 0} -> 2
      {2, 0} -> 3
      {0, 1} -> 4
      {1, 1} -> 5
      {2, 1} -> 6
      {0, 2} -> 7
      {1, 2} -> 8
      {2, 2} -> 9
    end
  end
  
  @doc """
      iex> Day2.key({1, 1}, 1)
      "2"
      
      iex> Day2.key({2, 2}, 1)
      "7"
      
      iex> Day2.key({0, 0}, 1)
      nil
  """
  def key(pos, type) when type == 1 do
    case pos do
      {2, 0} -> "1"
      {1, 1} -> "2"
      {2, 1} -> "3"
      {3, 1} -> "4"
      {0, 2} -> "5"
      {1, 2} -> "6"
      {2, 2} -> "7"
      {3, 2} -> "8"
      {4, 2} -> "9"
      {1, 3} -> "A"
      {2, 3} -> "B"
      {3, 3} -> "C"
      {2, 4} -> "D"
      _ -> nil
    end
  end
  
  @doc """
      iex> Day2.move({1, 1}, "U")
      {1, 0}
      
      iex> Day2.move({1, 0}, "U")
      {1, 0}
      
      iex> Day2.move({0, 0}, "U")
      {0, 0}
      
      iex> Day2.move({0, 0}, "L")
      {0, 0}
  """
  def move({x, y}, direction) do
    case direction do
      "U" ->
        {x, max(0, y - 1)}
      "D" ->
        {x, min(2, y + 1)}
      "L" ->
        {max(0, x - 1), y}
      "R" ->
        {min(2, x + 1), y}
    end
  end
  
  
  def move_2({x, y}, direction) do
    case direction do
      "U" ->
        newY = max(0, y - 1)
        if key({x, newY}, 1) == nil, do: {x, y}, else: {x, newY}
      "D" ->
        newY = min(4, y + 1)
        if key({x, newY}, 1) == nil, do: {x, y}, else: {x, newY}
      "L" ->
        newX = max(0, x - 1)
        if key({newX, y}, 1) == nil, do: {x, y}, else: {newX, y}
      "R" ->
        newX = min(4, x + 1)
        if key({newX, y}, 1) == nil, do: {x, y}, else: {newX, y}
    end
  end
end
