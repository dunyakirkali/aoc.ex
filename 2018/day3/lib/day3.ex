defmodule Day3 do
  @moduledoc """
  Documentation for Day3.
  """

  @doc """
  Parse a single claim

  ## Examples

      iex> Day3.parse_claim("#1 @ 1,3: 4x4")
      [1, 1, 3, 4, 4]

  """
  def parse_claim(string) do
    Regex.named_captures(~r/#(?<a>\d+) @ (?<b>\d+),(?<c>\d+): (?<d>\d+)x(?<e>\d+)/, string)
    |> Map.values
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
  Map of claimed inches

  ## Examples

      iex> claimed = Day3.claimed_inches(["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"])
      iex> claimed[{4, 2}]
      [2]
      iex> claimed[{4, 4}]
      [2, 1]

  """
  def claimed_inches(list) do
    list
    |> Enum.reduce(%{}, fn claim, acc ->
      [id, left, top, width, height] = parse_claim(claim)

      Enum.reduce((left + 1)..(left + width), acc, fn x, acc ->
        Enum.reduce((top + 1)..(top + height), acc, fn y, acc ->
          Map.update(acc, {x, y}, [id], &[id | &1])
        end)
      end)
    end)
  end

  @doc """
  Overlapping inches

  ## Examples

      iex> Day3.overlapping(["#1 @ 1,3: 4x4", "#2 @ 3,1: 4x4", "#3 @ 5,5: 2x2"]) |> Enum.sort
      [{4, 4}, {4, 5}, {5, 4}, {5, 5}]

  """
  def overlapping(claims) do
    for {coordinate, [_, _ | _]} <- claimed_inches(claims) do
      coordinate
    end
  end
end
