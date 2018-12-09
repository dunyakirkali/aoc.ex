defmodule Day9 do
  @moduledoc """
  Documentation for Day9.
  """

  @doc """
      iex> Day9.highest_score(9, 25)
      32

      iex> Day9.highest_score(10, 1618)
      8317

      iex> Day9.highest_score(13, 7999)
      146373

      iex> Day9.highest_score(17, 1104)
      2764

      iex> Day9.highest_score(21, 6111)
      54718

      iex> Day9.highest_score(30, 5807)
      37305
  """
  def highest_score(no_players, no_marbles) do
    1..(no_marbles + 1)
    |> Enum.to_list
    |> Enum.reduce({%{}, 0, [0]}, fn x, acc ->
      {scores, current_marble_pos, chain} = acc
      next_marble_pos = get_pos(current_marble_pos, chain)

      if rem(x, 23) == 0 do
        next_marble_pos = current_marble_pos - 7
        if next_marble_pos < 0 do
          next_marble_pos = length(chain) + next_marble_pos
          {removed_marble, chain} = List.pop_at(chain, next_marble_pos)
          score = x + removed_marble
          scores = Map.update(scores, rem(x, no_players), score, &(&1 + score))

          {scores, next_marble_pos, chain}
        else
          {removed_marble, chain} = List.pop_at(chain, next_marble_pos)
          score = x + removed_marble
          scores = Map.update(scores, rem(x, no_players), score, &(&1 + score))

          {scores, next_marble_pos, chain}
        end
      else
        chain = List.insert_at(chain, next_marble_pos, x)

        {scores, next_marble_pos, chain}
      end
    end)
    |> elem(0)
    # |> IO.inspect(label: "scores")
    |> Map.values()
    |> Enum.max()
  end

  @doc """
      iex> Day9.get_pos(0, [])
      0

      iex> Day9.get_pos(0, [0])
      1

      iex> Day9.get_pos(1, [0, 1])
      1

      iex> Day9.get_pos(1, [0, 2, 1])
      3

      iex> Day9.get_pos(3, [0, 2, 1, 3])
      1

      iex> Day9.get_pos(11, [0, 16, 8, 17, 4, 18, 9, 19, 2, 20, 10, 21, 5, 11, 1, 12, 6, 13, 3, 14, 7, 15])
      13
  """
  def get_pos(_, chain) when length(chain) == 0, do: 0
  def get_pos(_, chain) when length(chain) == 1, do: 1
  def get_pos(marble, chain) when length(chain) == marble + 2 do
    length(chain)
  end
  def get_pos(marble, chain) do
    rem(marble + 2, length(chain))
  end
end
