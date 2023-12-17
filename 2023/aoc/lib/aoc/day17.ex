defmodule Aoc.Day17 do
  @doc """
      iex> "priv/day17/example.txt" |> Aoc.Day17.input() |> Aoc.Day17.part1()
      102
  """
  def part1(map) do
    start = {0, 0}

    queue = PriorityQueue.new() |> PriorityQueue.push({start, :right, 0, 0}, 0)

    visited = MapSet.new([])
    size = size(map)

    walk(map, queue, visited, size)
  end

  def walk(map, deque, visited, {width, height}) do
    {{:value, {pos, direction, steps, hl}}, deque} = PriorityQueue.pop(deque)

    if pos == {width - 1, height - 1} do
      hl
    else
      if MapSet.member?(visited, {pos, direction, steps}) do
        walk(map, deque, visited, {width, height})
      else
        visited = MapSet.put(visited, {pos, direction, steps})

        deque =
          options(pos, direction, steps, 3)
          |> Enum.filter(fn {{nx, ny}, _steps, _direction} ->
            nx > -1 and ny > -1 and nx < width and ny < height
          end)
          |> Enum.reduce(deque, fn {npos, nsteps, ndirection}, accd ->
            val = Map.get(map, npos)

            PriorityQueue.push(accd, {npos, ndirection, nsteps, hl + val}, hl + val)
          end)

        walk(map, deque, visited, {width, height})
      end
    end
  end

  def draw(map) do
    IO.puts("\n")

    {minx, maxx} =
      map
      |> Map.keys()
      |> Enum.map(&elem(&1, 0))
      |> Enum.min_max()

    {miny, maxy} =
      map
      |> Map.keys()
      |> Enum.map(&elem(&1, 1))
      |> Enum.min_max()

    Enum.each(miny..maxy, fn y ->
      Enum.map(minx..maxx, fn x ->
        Map.get(map, {x, y}, ".")
      end)
      |> Enum.join("")
      |> IO.puts()
    end)

    IO.puts("\n")
    map
  end

  @doc """
      iex> Aoc.Day17.options({0, 0}, :right, 0, 3)
      [{{1, 0}, 1, :right}, {{0, -1}, 1, :up}, {{0, 1}, 1, :down}]

      iex> Aoc.Day17.options({0, 0}, :right, 3, 3)
      [{{0, -1}, 1, :up}, {{0, 1}, 1, :down}]
  """
  def options({x, y}, :right, steps, min) do
    [
      {{x, y - 1}, 1, :up},
      {{x, y + 1}, 1, :down}
    ]
    |> then(fn list ->
      if steps == min do
        list
      else
        [{{x + 1, y}, steps + 1, :right} | list]
      end
    end)
  end

  def options({x, y}, :left, steps, min) do
    [
      {{x, y - 1}, 1, :up},
      {{x, y + 1}, 1, :down}
    ]
    |> then(fn list ->
      if steps == min do
        list
      else
        [{{x - 1, y}, steps + 1, :left} | list]
      end
    end)
  end

  def options({x, y}, :up, steps, min) do
    [
      {{x - 1, y}, 1, :left},
      {{x + 1, y}, 1, :right}
    ]
    |> then(fn list ->
      if steps == min do
        list
      else
        [{{x, y - 1}, steps + 1, :up} | list]
      end
    end)
  end

  def options({x, y}, :down, steps, min) do
    [
      {{x - 1, y}, 1, :left},
      {{x + 1, y}, 1, :right}
    ]
    |> then(fn list ->
      if steps == min do
        list
      else
        [{{x, y + 1}, steps + 1, :down} | list]
      end
    end)
  end

  @doc """
      iex> "priv/day17/example.txt" |> Aoc.Day17.input() |> Aoc.Day17.part2()
      94

      iex> "priv/day17/example2.txt" |> Aoc.Day17.input() |> Aoc.Day17.part2()
      71
  """
  def part2(map) do
    start = {0, 0}

    queue = PriorityQueue.new() |> PriorityQueue.push({start, :right, 0, 0}, 0)

    visited = MapSet.new([])
    size = size(map)

    walk2(map, queue, visited, size)
  end

  def walk2(map, deque, visited, {width, height}) do
    {{:value, {pos, direction, steps, hl}}, deque} = PriorityQueue.pop(deque)

    if pos == {width - 1, height - 1} and steps >= 4 do
      hl
    else
      if MapSet.member?(visited, {pos, direction, steps}) do
        walk2(map, deque, visited, {width, height})
      else
        # IO.inspect(hl)
        visited = MapSet.put(visited, {pos, direction, steps})

        deque =
          options(pos, direction, steps, 10)
          # |> IO.inspect(label: "rop")
          |> Enum.filter(fn {_pos, _steps, dir} ->
            steps >= 4 or direction == dir
          end)
          |> Enum.filter(fn {{nx, ny}, _steps, _direction} ->
            nx > -1 and ny > -1 and nx < width and ny < height
          end)
          # |> IO.inspect(label: "opt")
          |> Enum.reduce(deque, fn {npos, nsteps, ndirection}, accd ->
            val = Map.get(map, npos)

            PriorityQueue.push(accd, {npos, ndirection, nsteps, hl + val}, hl + val)
          end)

        walk2(map, deque, visited, {width, height})
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
        Map.put(aacc, {x, y}, String.to_integer(cell))
      end)
    end)
  end
end
