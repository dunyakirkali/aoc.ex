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
      8
  """
  def part2(map) do
    sp = start(map)

    deque =
      Deque.new(19_600)
      |> Deque.appendleft(sp)

    path =
      wonder(map, deque, [sp])

    nmap =
      map
      |> Enum.map(fn {pos, v} ->
        if Enum.member?(path, pos) do
          {pos, v}
        else
          {pos, "."}
        end
      end)
      |> Enum.into(%{})

    nmap
    |> draw
    |> Enum.filter(fn {_, val} -> val == "." end)
    |> Enum.into(%{})
    |> draw
    |> Enum.count(fn {pos, _} ->
      inside?(nmap, pos)
    end)
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

    Enum.each(miny..maxy, fn y ->
      Enum.map(minx..maxx, fn x ->
        Map.get(map, {x, y}, "■")
      end)
      |> Enum.join("")
      |> IO.puts()
    end)

    IO.puts("\n")
    map
  end

  def inside?(map, {x, y}) do
    0..x
    |> Enum.map(fn i -> {i, y} end)
    |> Enum.map(fn pos -> Map.get(map, pos) end)
    |> Enum.filter(fn val -> Enum.member?(["|", "J", "L"], val) end)
    |> Enum.count()
    |> Kernel.rem(2)
    |> Kernel.==(1)
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
