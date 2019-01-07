defmodule Day3 do
  @moduledoc """
  Documentation for Day3.
  """
  
  @doc """
      iex> Day3.part_1([{5, 10, 15}, {3, 4, 5}])
      1
  """
  def part_1(triangles) do
    triangles
    |> Enum.map(fn triangle ->
      verify(triangle)
    end)
    |> Enum.filter(fn x ->
      x == true
    end)
    |> Enum.count
  end

  @doc """
      iex> Day3.verify({5, 10, 25})
      false
  """
  def verify({a, b, c}) do
    (a + b) > c and (a + c) > b and (c + b) > a
  end
end
