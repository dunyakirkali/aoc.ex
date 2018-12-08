defmodule Day1 do
  import NimbleParsec

  @moduledoc """
  Documentation for Day1.
  """

  defparsec(:parse, choice([string("R"), string("L")]) |> integer(max: 3))

  @doc """
      iex> Day1.follow(["R2", "L3"])
      5

      iex> Day1.follow(["R2", "R2", "R2"])
      2

      iex> Day1.follow(["R2", "R2", "R2"])
      2

      iex> Day1.follow(["R5", "L5", "R5", "R3"])
      12
  """
  def follow(path) do
    path
    |> Enum.reduce({{0, 0}, :n}, fn step, acc ->
      position = elem(acc, 0)
      heading = elem(acc, 1)
      {:ok, [rotation, amount], _, _, _, _} = parse(step)

      head_to = rotate(heading, rotation)
      move_to = advance(position, head_to, amount)
      {move_to, head_to}
    end)
    |> elem(0)
    |> Tuple.to_list()
    |> Enum.map(fn x -> abs(x) end)
    |> Enum.sum()
  end

  @doc """
      iex> Day1.advance({0, 0}, :n, 5)
      {0, 5}

      iex> Day1.advance({0, 0}, :w, 5)
      {-5, 0}
  """
  def advance(pos, heading, amount) do
    case heading do
      :n ->
        {elem(pos, 0), elem(pos, 1) + amount}

      :e ->
        {elem(pos, 0) + amount, elem(pos, 1)}

      :s ->
        {elem(pos, 0), elem(pos, 1) - amount}

      :w ->
        {elem(pos, 0) - amount, elem(pos, 1)}
    end
  end

  @doc """
      iex> Day1.rotate(:n, "R")
      :e

      iex> Day1.rotate(:w, "L")
      :s
  """
  def rotate(heading, rotation) do
    case {heading, rotation} do
      {:n, "R"} ->
        :e

      {:e, "R"} ->
        :s

      {:s, "R"} ->
        :w

      {:w, "R"} ->
        :n

      {:n, "L"} ->
        :w

      {:w, "L"} ->
        :s

      {:s, "L"} ->
        :e

      {:e, "L"} ->
        :n
    end
  end
end
