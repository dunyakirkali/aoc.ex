defmodule Aoc.Day23 do
  @doc """
      iex> "priv/day23/example.txt" |> Aoc.Day23.input() |> Aoc.Day23.part1()
      94
  """
  def part1(map) do
    {width, height} = size(map)
    sp = start(map)
    ep = finish(map)
    pq = Deque.new(1_000_000) |> Deque.append({sp, [sp]})

    max_distance = 0
    longest = []

    solve(map, pq, longest, ep, {width, height}, max_distance)
  end

  def solve(map, pq, longest, ep, {width, height}, max_distance) do
    case Deque.popleft(pq) do
      {nil, pq} ->
        IO.puts(max_distance - 1)

      {{np, path}, pq} ->
        pq =
          np
          |> neighbours()
          |> Enum.filter(fn {{x, y}, _} ->
            x > -1 and y > -1 and x < width and y < height
          end)
          |> Enum.filter(fn {pos, dir} ->
            Map.get(map, pos, ".") == "." or
              Map.get(map, pos, ".") ==
                case dir do
                  :right -> ">"
                  :left -> "<"
                  :up -> "^"
                  :down -> "v"
                end
          end)
          |> Enum.reduce(pq, fn {pos, dir} = n, acc ->
            # PriorityQueue.push(acc, n, width * height - manhattan(pos, ep))
            Deque.appendleft(acc, n)
          end)

        # |> IO.inspect()

        # if np == ep do
        #   visited
        #   IO.inspect(Enum.count(visited))
        #   solve(map, pq, visited, ep, {width, height})
        # else
        #   solve(map, pq, visited, ep, {width, height})
        # end
    end
  end

  def neighbours({x, y}) do
    [
      {{x + 1, y}, :right},
      {{x, y + 1}, :down},
      {{x - 1, y}, :left},
      {{x, y - 1}, :up}
    ]
  end

  def manhattan({fx, fy}, {tx, ty}) do
    abs(fx - tx) + abs(fy - ty)
  end

  @doc """
      iex> "priv/day23/example.txt" |> Aoc.Day23.input() |> Aoc.Day23.start()
      {1, 0}
  """
  def start(map) do
    map
    |> Enum.find(fn {{_, y}, v} ->
      y == 0 and v == "."
    end)
    |> elem(0)
  end

  @doc """
      iex> "priv/day23/example.txt" |> Aoc.Day23.input() |> Aoc.Day23.finish()
      {21, 22}
  """
  def finish(map) do
    {width, height} = size(map)

    map
    |> Enum.find(fn {{_, y}, v} ->
      y == height - 1 and v == "."
    end)
    |> elem(0)
  end

  @doc """
      iex> "priv/day23/example.txt" |> Aoc.Day23.input() |> Aoc.Day23.size()
      {23, 23}
  """
  def size(map) do
    map
    |> Map.keys()
    |> Enum.reduce({0, 0}, fn {x, y}, {maxX, maxY} ->
      {max(x, maxX), max(y, maxY)}
    end)
    |> Tuple.to_list()
    |> Enum.map(&(&1 + 1))
    |> List.to_tuple()
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
    end)
    |> Enum.with_index()
    |> Enum.reduce(Map.new(), fn {line, y}, acc ->
      line
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {cell, x}, aacc ->
        Map.put(aacc, {x, y}, cell)
      end)
    end)
  end
end
