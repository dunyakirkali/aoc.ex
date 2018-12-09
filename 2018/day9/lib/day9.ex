defmodule Day9 do
  @moduledoc """
  Documentation for Day9.
  """

  @doc """
      iex> Day9.highest_score(9, 25)
      32

      iex> Day9.highest_score(10, 1618)
      8317
      #
      # iex> Day9.highest_score(13, 7999)
      # 146373
      #
      # iex> Day9.highest_score(17, 1104)
      # 2764
      #
      # iex> Day9.highest_score(21, 6111)
      # 54718
      #
      # iex> Day9.highest_score(30, 5807)
      # 37305
  """
  def highest_score(no_players, no_marbles) do
    1..(no_marbles + 1)
    |> Enum.to_list
    |> Enum.reduce({%{}, 0, %{0 => 0}}, fn x, acc ->
      IO.puts("~> #{x}")
      {scores, current_marble_pos, chain} = acc

      if rem(x, 23) == 0 do

        next_marble_pos = current_marble_pos - 7
        map_pos = rem(x, no_players)
        next_marble_pos =
          if next_marble_pos < 0 do
            length(Map.keys(chain)) + next_marble_pos
          else
            next_marble_pos
          end
        {removed_marble, chain} = pop(chain, next_marble_pos)
        score = x + removed_marble

        scores = Map.update(scores, map_pos, [score], fn y -> [score | y] end)

        {scores, next_marble_pos, chain}
      else
        next_marble_pos = get_pos(current_marble_pos, chain)
        chain = insert_at(chain, next_marble_pos, x)

        {scores, next_marble_pos, chain}
      end
    end)
    |> elem(0)
    |> Map.values()
    |> Enum.map(&Enum.sum/1)
    |> Enum.max()
  end

  def insert_at(map, index, value) do
    if index == length(Map.keys(map)) do
      Map.put(map, index, value)
    else
      nval = Map.get(map, index)
      map = Map.put(map, index, value)
      insert_at(map, index + 1, nval)
    end
  end

  def pop(map, index) do
    {removed_marble, map} = Map.pop(map, index)
    keys = Map.keys(map) |> Enum.map(fn x ->
      if x > index do
        x - 1
      else
        x
      end
    end)
    values = Map.values(map)
    map = List.zip([keys, values]) |> Enum.into(%{})
    {removed_marble, map}
  end

  @doc """
      iex> Day9.get_pos(0, %{})
      0

      iex> Day9.get_pos(0, %{0 => 0})
      1

      iex> Day9.get_pos(1, %{0 => 0, 1 => 1})
      1

      iex> Day9.get_pos(1, %{0 => 0, 1 => 2, 2 => 1})
      3

      iex> Day9.get_pos(3, %{0 => 0, 1 => 2, 2 => 1, 3 => 3})
      1

      iex> Day9.get_pos(11, %{0 => 0, 1 => 16, 2 => 8, 3 => 17, 4 => 4, 5 => 18, 6 => 9, 7 => 19, 8 => 2, 9 => 20, 10 => 10, 11 => 21, 12 => 5, 13 => 11, 14 => 1, 15 => 12, 16 => 6, 17 => 13, 18 => 3, 19 => 14, 20 => 7, 21 => 5})
      13
  """
  def get_pos(marble, chain) do
    len = length(Map.keys(chain))
    case len do
      0 -> 0
      1 -> 1
      _ ->
        if len == marble + 2 do
          len
        else
          rem(marble + 2, len)
        end
    end
  end
end
