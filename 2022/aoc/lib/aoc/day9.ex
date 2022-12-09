defmodule Aoc.Day9 do
  use Agent

  def start do
    Agent.start_link(fn -> %{} end, name: __MODULE__)
  end

  @doc """
      iex> "priv/day9/example.txt" |> Aoc.Day9.input() |> Aoc.Day9.part1()
      13
  """
  def part1(moves) do
    start()

    moves
    |> Enum.reduce({{0, 0}, [{0, 0}], MapSet.new()}, fn {direction, amount}, acc ->
      1..amount
      |> Enum.reduce(acc, fn _, {{hx, hy}, tails, visited} ->
        {hnx, hny} = move_head(direction, {hx, hy})

        tails =
          tails
          |> Enum.with_index()
          |> Enum.map(fn {tail, index} ->
            case index do
              0 ->
                nt = move_tail({hnx, hny}, tail)
                Agent.update(__MODULE__, &Map.put(&1, index, nt))
                nt

              _ ->
                pt = Agent.get(__MODULE__, &Map.get(&1, index - 1))
                nt = move_tail(pt, tail)
                Agent.update(__MODULE__, &Map.put(&1, index, nt))
                nt
            end
          end)

        tail = List.last(tails)

        {{hnx, hny}, tails, MapSet.put(visited, tail)}
      end)
    end)
    |> elem(2)
    |> MapSet.size()
  end

  @doc """
      iex> "priv/day9/example.txt" |> Aoc.Day9.input() |> Aoc.Day9.part2()
      1

      iex> "priv/day9/example2.txt" |> Aoc.Day9.input() |> Aoc.Day9.part2()
      36
  """
  def part2(moves) do
    start()

    tails = for _ <- 1..9, do: {0, 0}

    moves
    |> Enum.reduce({{0, 0}, tails, MapSet.new()}, fn {direction, amount}, acc ->
      1..amount
      |> Enum.reduce(acc, fn _, {{hx, hy}, tails, visited} ->
        {hnx, hny} = move_head(direction, {hx, hy})

        tails =
          tails
          |> Enum.with_index()
          |> Enum.map(fn {tail, index} ->
            case index do
              0 ->
                nt = move_tail({hnx, hny}, tail)
                Agent.update(__MODULE__, &Map.put(&1, index, nt))
                nt

              _ ->
                pt = Agent.get(__MODULE__, &Map.get(&1, index - 1))
                nt = move_tail(pt, tail)
                Agent.update(__MODULE__, &Map.put(&1, index, nt))
                nt
            end
          end)

        tail = List.last(tails)

        {{hnx, hny}, tails, MapSet.put(visited, tail)}
      end)
    end)
    |> elem(2)
    |> MapSet.size()
  end

  def move_head(direction, {hx, hy}) do
    case direction do
      "U" -> {hx, hy - 1}
      "D" -> {hx, hy + 1}
      "L" -> {hx - 1, hy}
      "R" -> {hx + 1, hy}
    end
  end

  def move_tail({hx, hy}, {tx, ty}) do
    dr = hx - tx
    dc = hy - ty

    cond do
      Kernel.abs(dr) <= 1 and Kernel.abs(dc) <= 1 ->
        {tx, ty}

      Kernel.abs(dr) >= 2 and Kernel.abs(dc) >= 2 ->
        {if(tx < hx, do: hx - 1, else: hx + 1), if(ty < hy, do: hy - 1, else: hy + 1)}

      Kernel.abs(dr) >= 2 ->
        {if(tx < hx, do: hx - 1, else: hx + 1), hy}

      Kernel.abs(dc) >= 2 ->
        {hx, if(ty < hy, do: hy - 1, else: hy + 1)}

      true ->
        IO.puts("WAT")
        {tx, ty}
    end
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [direction, amount] = String.split(line, " ", trim: true)
      {direction, String.to_integer(amount)}
    end)
  end
end
