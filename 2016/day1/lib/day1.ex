defmodule Day1 do
  @moduledoc """
  Documentation for Day1.
  """

  @doc """
  Part 1

  ## Examples

      iex> Day1.solve("R1, L2")
      3

  """
  def solve(route) do
    state = %{
      direction: :north,
      position: {0, 0}
    }
    regex = ~r/(?<direction>R|L)(?<amount>\d+)/
    
    route
      |> String.split(", ")
      |> Enum.map(fn(x) -> Regex.named_captures(regex, x) end)
      |> Day1.step(state)
      |> Day1.distance
  end
  
  def distance(%{ position: position }) do
    abs(elem(position, 0)) + abs(elem(position, 1))
  end
  
  def step([head | tail], state) do
    new_state = state
      |> Day1.rotate(head["direction"])
      |> Day1.move(elem(Integer.parse(head["amount"]), 0))
    Day1.step(tail, new_state)
  end
  
  def step([], state) do
    state
  end

  def move(%{ direction: direction, position: position }, amount) do
    case direction do
      :north -> %{ direction: direction, position: Kernel.put_elem(position, 1, elem(position, 1) - amount) }
      :south -> %{ direction: direction, position: Kernel.put_elem(position, 1, elem(position, 1) + amount) }
      :east -> %{ direction: direction, position: Kernel.put_elem(position, 0, elem(position, 0) + amount) }
      :west -> %{ direction: direction, position: Kernel.put_elem(position, 0, elem(position, 0) - amount) }
    end
  end
  
  def rotate(%{ direction: direction, position: position }, rotation) do
    case direction do
      :north -> if (rotation == "R"), do: %{ direction: :east, position: position }, else: %{ direction: :west, position: position }
      :south -> if (rotation == "R"), do: %{ direction: :west, position: position }, else: %{ direction: :east, position: position }
      :east -> if (rotation == "R"), do: %{ direction: :south, position: position }, else: %{ direction: :north, position: position }
      :west -> if (rotation == "R"), do: %{ direction: :north, position: position }, else: %{ direction: :south, position: position }
    end
  end
end
