defmodule Aoc.Day16 do
  use Agent

  def start() do
    Agent.start_link(fn -> MapSet.new() end, name: :energized)
  end

  @doc """
      iex> "priv/day16/example.txt" |> Aoc.Day16.input() |> Aoc.Day16.part1()
      46
  """
  def part1(map) do
    start = {-1, 0}

    deque =
      Deque.new(1_000_000)
      |> Deque.appendleft({start, :right})

    visited = MapSet.new([])

    walk(map, deque, visited)
    |> Enum.map(fn {pos, _} -> pos end)
    |> Enum.uniq()
    |> Enum.count()
    |> Kernel.-(1)
  end

  def walk(map, deque, visited) do
    {width, height} = size(map)

    if Enum.count(deque) == 0 do
      visited
    else
      {{pos, direction}, deque} = Deque.popleft(deque)
      visited = MapSet.put(visited, {pos, direction})

      deque =
        tick(map, pos, direction)
        |> Enum.filter(fn {{nx, ny}, _ndir} ->
          nx > -1 and ny > -1 and nx < width and ny < height
        end)
        |> Enum.filter(fn {pos, ndir} ->
          not MapSet.member?(visited, {pos, ndir})
        end)
        |> Enum.reduce(deque, fn elem, acc ->
          Deque.appendleft(acc, elem)
        end)

      walk(map, deque, visited)
    end
  end

  @doc """
      iex> "priv/day16/example.txt" |> Aoc.Day16.input() |> Aoc.Day16.part2()
      51
  """
  def part2(map) do
    {width, height} = size(map)

    tops =
      0..(width - 1)
      |> Enum.map(fn x -> {{x, 0}, :down} end)

    bottoms =
      0..(width - 1)
      |> Enum.map(fn x -> {{x, height - 1}, :up} end)

    lefts =
      0..(height - 1)
      |> Enum.map(fn y -> {{0, y}, :right} end)

    rights =
      0..(height - 1)
      |> Enum.map(fn y -> {{width - 1, y}, :left} end)

    (tops ++ bottoms ++ lefts ++ rights)
    |> Stream.map(fn {pos, dir} ->
      deque =
        Deque.new(1_000_000)
        |> Deque.appendleft({pos, dir})

      visited = MapSet.new([])

      walk(map, deque, visited)
      |> Enum.map(fn {pos, _} -> pos end)
      |> Enum.uniq()
      |> Enum.count()
    end)
    |> Enum.max()
  end

  def tick(map, {x, y} = pos, direction) do
    cur = Map.get(map, pos, ".")

    case cur do
      "." ->
        [
          {
            case direction do
              :right -> {x + 1, y}
              :left -> {x - 1, y}
              :up -> {x, y - 1}
              :down -> {x, y + 1}
            end,
            direction
          }
        ]

      "|" ->
        case direction do
          :up ->
            [{{x, y - 1}, :up}]

          :down ->
            [{{x, y + 1}, :down}]

          _ ->
            [
              {{x, y - 1}, :up},
              {{x, y + 1}, :down}
            ]
        end

      "-" ->
        case direction do
          :right ->
            [{{x + 1, y}, :right}]

          :left ->
            [{{x - 1, y}, :left}]

          _ ->
            [
              {{x + 1, y}, :right},
              {{x - 1, y}, :left}
            ]
        end

      "/" ->
        case direction do
          :right -> [{{x, y - 1}, :up}]
          :left -> [{{x, y + 1}, :down}]
          :up -> [{{x + 1, y}, :right}]
          :down -> [{{x - 1, y}, :left}]
        end

      "\\" ->
        case direction do
          :right -> [{{x, y + 1}, :down}]
          :left -> [{{x, y - 1}, :up}]
          :up -> [{{x - 1, y}, :left}]
          :down -> [{{x + 1, y}, :right}]
        end
    end
  end

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
        if cell == "." do
          aacc
        else
          Map.put(aacc, {x, y}, cell)
        end
      end)
    end)
  end
end
