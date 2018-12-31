defmodule Day1 do
  import NimbleParsec

  @moduledoc """
  Documentation for Day1.
  """

  defparsec(:parse, choice([string("R"), string("L")]) |> integer(max: 3))

  @doc """
      iex> Day1.part_2(["R8", "R4", "R4", "R8"])
      4
  """
  def part_2(path) do
    path
    |> Stream.cycle()
    |> Enum.reduce_while({{0, 0}, :n, []}, fn step, {position, heading, visited} ->
      {:ok, [rotation, amount], _, _, _, _} = parse(step)

      head_to = rotate(heading, rotation)
      move_to = advance(position, head_to, amount)

      route =
        for x <- elem(position, 0)..elem(move_to, 0),
            y <- elem(position, 1)..elem(move_to, 1),
            do: {x, y}

      route = List.delete(route, position)

      been_there_done_thats =
        Enum.map(route, fn pos ->
          if Enum.member?(visited, pos) do
            pos
          end
        end)
        |> Enum.reject(&is_nil/1)

      if Enum.count(been_there_done_thats) > 0 do
        {:halt, List.first(been_there_done_thats)}
      else
        visited = Enum.concat(visited, route)
        {:cont, {move_to, head_to, visited}}
      end
    end)
    |> Tuple.to_list()
    |> Enum.map(fn x -> abs(x) end)
    |> Enum.sum()
  end

  @doc """
      iex> Day1.part_1(["R2", "L3"])
      5

      iex> Day1.part_1(["R2", "R2", "R2"])
      2

      iex> Day1.part_1(["R2", "R2", "R2"])
      2

      iex> Day1.part_1(["R5", "L5", "R5", "R3"])
      12
  """
  def part_1(path) do
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
