defmodule Day2 do
  @moduledoc """
  Documentation for Day2.
  """

  @doc """
      iex> Day2.part_1([
      ...>   "ULL",
      ...>   "RRDDD",
      ...>   "LURDL",
      ...>   "UUUUD"
      ...> ])
      1985
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
      {[key(pos) | acc], pos}
    end)
    |> elem(0)
    |> Enum.reverse()
    |> Enum.join()
    |> String.to_integer()
  end
  
  @doc """
      iex> Day2.key({1, 1})
      5
      
      iex> Day2.key({2, 2})
      9
  """
  def key(pos) do
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
end
