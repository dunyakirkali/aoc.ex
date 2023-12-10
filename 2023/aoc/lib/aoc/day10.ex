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

    wonder(map, deque, MapSet.new([sp]))
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
        if y > 0 and
             Enum.member?(["S", "|", "J", "L"], ch) and
             Enum.member?(["|", "7", "F"], Map.get(map, {x, y - 1})) and
             not Enum.member?(visited, {x, y - 1}) do
          {Deque.appendleft(deque, {x, y - 1}), MapSet.put(visited, {x, y - 1})}
        else
          {deque, visited}
        end

      {deque, visited} =
        if y < Enum.map(map, fn {{_x, y}, _v} -> y end) |> Enum.max() and
             Enum.member?(["S", "|", "F", "7"], ch) and
             Enum.member?(["|", "J", "L"], Map.get(map, {x, y + 1})) and
             not Enum.member?(visited, {x, y + 1}) do
          {Deque.appendleft(deque, {x, y + 1}), MapSet.put(visited, {x, y + 1})}
        else
          {deque, visited}
        end

      {deque, visited} =
        if x > 0 and
             Enum.member?(["S", "-", "J", "7"], ch) and
             Enum.member?(["-", "L", "F"], Map.get(map, {x - 1, y})) and
             not Enum.member?(visited, {x - 1, y}) do
          {Deque.appendleft(deque, {x - 1, y}), MapSet.put(visited, {x - 1, y})}
        else
          {deque, visited}
        end

      {deque, visited} =
        if x < Enum.map(map, fn {{x, _y}, _v} -> x end) |> Enum.max() and
             Enum.member?(["S", "-", "L", "F"], ch) and
             Enum.member?(["-", "J", "7"], Map.get(map, {x + 1, y})) and
             not Enum.member?(visited, {x + 1, y}) do
          {Deque.appendleft(deque, {x + 1, y}), MapSet.put(visited, {x + 1, y})}
        else
          {deque, visited}
        end

      wonder(map, deque, visited)
    end
  end

  def walk(map, acc, direction, pos, steps, visited) do
    # if Enum.member?(visited, pos) do
    #   acc
    # else
    #   pos |> IO.inspect(label: "cp")
    #   direction |> IO.inspect(label: "cd")
    #   cc = Map.get(map, pos) |> IO.inspect(label: "cc")
    #
    #   np =
    #     pos
    #     |> neighbours()
    #     |> Enum.filter(fn x -> !Enum.member?(visited, x) end)
    #     |> Enum.filter(fn nasd ->
    #       direction
    #       |> valid_in()
    #       |> Enum.member?(Map.get(map, nasd, "."))
    #     end)
    #     |> IO.inspect(label: "nps")
    #     |> Enum.at(0)
    #
    #   # Enum.flat_map(nps, fn np ->
    #   nd =
    #     next_direction(Map.get(map, np), direction)
    #
    #   acc = Map.put(acc, pos, steps)
    #   draw(acc)
    #   walk(map, acc, nd, np, steps + 1, [pos | visited])
    #   # end)
    #   # |> Enum.into(%{})
    # end
  end

  def next_direction(cc, cd) do
    case {cc, cd} do
      {"-", :right} -> :right
      {"-", :left} -> :left
      {"7", :right} -> :down
      {"7", :up} -> :left
      {"|", :down} -> :down
      {"|", :up} -> :up
      {"J", :down} -> :left
      {"J", :right} -> :up
      {"F", :left} -> :down
      {"F", :up} -> :right
      {"L", :down} -> :right
      {"L", :left} -> :up
      {"S", :right} -> :right
      {"S", :up} -> :up
      {"S", :down} -> :down
      {"S", :left} -> :left
    end
  end

  def start(map) do
    map
    |> Enum.find(fn {_, val} -> val == "S" end)
    |> elem(0)
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

  def valid_in(direction) do
    case direction do
      :right -> ["-", "7", "J", "S"]
      :down -> ["|", "J", "L", "S"]
      :left -> ["-", "L", "F", "S"]
      :up -> ["|", "F", "7", "S"]
    end
  end

  @doc """
      # iex> "priv/day10/example2.txt" |> Aoc.Day10.input() |> Aoc.Day10.part2()
      # 4
  """
  def part2(list) do
    list
    |> flood({0, 0}, [])
    |> Enum.filter(fn {_, v} -> v == "." end)
    |> Enum.count()
  end

  def flood(map, pos, visited) do
    draw(map)

    if Enum.member?(visited, pos) do
      map
    else
      pos
      |> neighbours()
      |> Enum.filter(fn {x, y} ->
        x <= Map.keys(map) |> Enum.map(fn p -> elem(p, 0) end) |> Enum.max() and
          y <= Map.keys(map) |> Enum.map(fn p -> elem(p, 1) end) |> Enum.max()
      end)
      |> Enum.filter(fn p -> Map.get(map, p, ".") == "." end)
      |> Enum.reduce(map, fn np, map ->
        flood(Map.put(map, np, "O"), np, [pos, visited])
      end)
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
