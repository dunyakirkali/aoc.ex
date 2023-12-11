defmodule Aoc.Day10 do
  @doc """
      iex> "priv/day10/example.txt" |> Aoc.Day10.input() |> Aoc.Day10.part1()
      4
  """
  def part1(map) do
    sp = start(map)

    deque =
      Deque.new(19_600)
      |> Deque.appendleft(sp)

    wonder(map, deque, [sp])
    |> Enum.count()
    |> Kernel./(2)
    |> Kernel.trunc()
  end

  def wonder(map, deque, visited) do
    if Enum.count(deque) == 0 do
      visited
    else
      {{x, y}, deque} =
        Deque.popleft(deque)

      ch = Map.get(map, {x, y})

      {deque, visited} =
        if x < Enum.map(map, fn {{x, _y}, _v} -> x end) |> Enum.max() and
             Enum.member?(["S", "-", "L", "F"], ch) and
             Enum.member?(["-", "J", "7"], Map.get(map, {x + 1, y})) and
             not Enum.member?(visited, {x + 1, y}) do
          {Deque.appendleft(deque, {x + 1, y}), [{x + 1, y} | visited]}
        else
          {deque, visited}
        end

      {deque, visited} =
        if y > 0 and
             Enum.member?(["S", "|", "J", "L"], ch) and
             Enum.member?(["|", "7", "F"], Map.get(map, {x, y - 1})) and
             not Enum.member?(visited, {x, y - 1}) do
          {Deque.appendleft(deque, {x, y - 1}), [{x, y - 1} | visited]}
        else
          {deque, visited}
        end

      {deque, visited} =
        if y < Enum.map(map, fn {{_x, y}, _v} -> y end) |> Enum.max() and
             Enum.member?(["S", "|", "F", "7"], ch) and
             Enum.member?(["|", "J", "L"], Map.get(map, {x, y + 1})) and
             not Enum.member?(visited, {x, y + 1}) do
          {Deque.appendleft(deque, {x, y + 1}), [{x, y + 1} | visited]}
        else
          {deque, visited}
        end

      {deque, visited} =
        if x > 0 and
             Enum.member?(["S", "-", "J", "7"], ch) and
             Enum.member?(["-", "L", "F"], Map.get(map, {x - 1, y})) and
             not Enum.member?(visited, {x - 1, y}) do
          {Deque.appendleft(deque, {x - 1, y}), [{x - 1, y} | visited]}
        else
          {deque, visited}
        end

      wonder(map, deque, visited)
    end
  end

  def start(map) do
    map
    |> Enum.find(fn {_, val} -> val == "S" end)
    |> elem(0)
  end

  @doc """
      iex> "priv/day10/example2.txt" |> Aoc.Day10.input() |> Aoc.Day10.part2()
      4

      iex> "priv/day10/example3.txt" |> Aoc.Day10.input() |> Aoc.Day10.part2()
      10
  """
  def part2(map) do
    sp =
      map
      |> start()
      |> IO.inspect(label: "start")

    deque =
      19_600
      |> Deque.new()
      |> Deque.appendleft(sp)

    path = wonder(map, deque, [sp])

    ordered_path =
      order(map, path, sp, :right, [])
      |> Enum.reverse()
      |> IO.inspect(label: "ordered_path")

    nmap =
      map
      |> Enum.map(fn {pos, v} ->
        if Enum.member?(Enum.map(ordered_path, fn {p, _} -> p end), pos) do
          {pos, v}
        else
          {pos, "."}
        end
      end)
      |> Enum.into(%{})
      |> draw

    find_outers(ordered_path, [])
    |> then(fn a ->
      Enum.count(a) |> IO.inspect()
      [{0, 0} | a]
    end)
    |> Enum.filter(fn p -> Map.get(nmap, p) == "." end)
    |> Enum.uniq()
    |> Enum.reduce({map, nmap}, fn pos, {om, nm} ->
      pos |> IO.inspect(label: "Flood from")
      draw(nm)
      res = flood({om, nm}, pos, [])
      res
    end)
    |> elem(1)
    |> draw()
    |> Enum.filter(fn {_, v} -> v == "." end)
    |> Enum.into(%{})
    |> Enum.count()
  end

  def order(map, path, {x, y} = pos, direction, acc) do
    if Enum.count(acc) > 1 and Map.get(map, pos) == "S" do
      acc
    else
      next_direction = pivot(Map.get(map, pos), direction)

      next_position =
        case next_direction do
          :right -> {x + 1, y}
          :down -> {x, y + 1}
          :left -> {x - 1, y}
          :up -> {x, y - 1}
        end

      order(map, List.delete(path, pos), next_position, next_direction, [{pos, direction} | acc])
    end
  end

  def find_outers([], acc), do: acc

  def find_outers([{{x, y}, direction} | t], acc) do
    np =
      case direction do
        :right -> {x, y - 1}
        :down -> {x + 1, y}
        :left -> {x, y + 1}
        :up -> {x - 1, y}
      end

    find_outers(t, [np | acc])
  end

  def pivot(char, direction) do
    case char do
      "|" ->
        direction

      "-" ->
        direction

      "L" ->
        case direction do
          :left -> :up
          :down -> :right
        end

      "J" ->
        case direction do
          :right -> :up
          :down -> :left
        end

      "7" ->
        case direction do
          :right -> :down
          :up -> :left
        end

      "F" ->
        case direction do
          :left -> :down
          :up -> :right
        end

      "S" ->
        :right
    end
  end

  def neighbours({x, y}) do
    [
      {x + 1, y},
      {x, y + 1},
      {x - 1, y},
      {x, y - 1}
    ]
    |> Enum.filter(fn {x, y} ->
      x > -1 and y > -1
    end)
  end

  def flood({om, nm}, pos, visited) do
    if Enum.member?(visited, pos) do
      {om, nm}
    else
      nnm =
        pos
        |> neighbours()
        |> then(fn ns ->
          [pos | ns]
        end)
        |> Enum.filter(fn {x, y} ->
          max_x = Map.keys(om) |> Enum.map(fn {x, _} -> x end) |> Enum.max()
          max_y = Map.keys(om) |> Enum.map(fn {_, y} -> y end) |> Enum.max()

          x <= max_x and y <= max_y
        end)
        |> Enum.filter(fn p -> Map.get(nm, p, ".") == "." end)
        |> Enum.reduce(nm, fn np, nmm ->
          {_, b} = flood({om, Map.put(nmm, np, "O")}, np, [pos | visited])
          b
        end)

      {om, nnm}
    end
  end

  def draw(map) do
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

    IO.puts("\n")

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
