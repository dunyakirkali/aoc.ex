defmodule Aoc.Day15 do
  @doc """
      iex> "priv/day15/example2.txt" |> Aoc.Day15.input() |> Aoc.Day15.part1()
      2028
  """
  def part1({robot, boxes, walls, directions}) do
    {robot, boxes, walls, directions}
    |> step()
    |> score()
  end

  def step({_, boxes, _, []}), do: boxes

  def step({robot, boxes, walls, [hd | td]}) do
    # draw(robot, boxes, walls)

    attempt_move(robot, boxes, walls, hd)
    |> Tuple.append(td)
    |> step()
  end

  def attempt_move(robot, boxes, walls, dir) do
    p2 = Enum.member?(Map.values(boxes), "[")

    affected =
      collect_affected(np(robot, dir), boxes, dir, [])

    if p2 do
      if Enum.count(affected) == 0 do
        if can_move?(robot, boxes, walls, dir) do
          np = np(robot, dir)
          {np, slide(np, boxes, dir), walls}
        else
          {robot, boxes, walls}
        end
      else
        if Enum.all?(affected, fn x -> can_move?(x, boxes, walls, dir) end) do
          np = np(robot, dir)
          {np, slide(np, boxes, dir), walls}
        else
          {robot, boxes, walls}
        end
      end
    else
      if can_move?(robot, boxes, walls, dir) do
        np = np(robot, dir)
        {np, slide(np, boxes, dir), walls}
      else
        {robot, boxes, walls}
      end
    end
  end

  def slide(position, boxes, dir) when dir == :up or dir == :down do
    p2 = Enum.member?(Map.values(boxes), "[")

    affected =
      if p2 do
        collect_affected(position, boxes, dir, [])
        |> Enum.sort_by(fn {_x, y} -> y end)
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.filter(fn [l, r] -> Map.get(boxes, l) == "[" and Map.get(boxes, r) == "]" end)
      else
        collect_affected(position, boxes, dir, [])
      end

    if p2 do
      boxes =
        affected
        |> List.flatten()
        |> Enum.reduce(boxes, fn pos, acc -> Map.delete(acc, pos) end)

      affected
      |> Enum.reduce(boxes, fn [lp, rp], acc ->
        acc
        |> Map.put(np(lp, dir), "[")
        |> Map.put(np(rp, dir), "]")
      end)
    else
      boxes =
        affected
        |> List.flatten()
        |> Enum.reduce(boxes, fn pos, acc -> Map.delete(acc, pos) end)

      affected
      |> List.flatten()
      |> Enum.reduce(boxes, fn pos, acc -> Map.put(acc, np(pos, dir), "O") end)
    end
  end

  def slide(position, boxes, dir) do
    p2 = Enum.member?(Map.values(boxes), "[")

    affected =
      collect_affected(position, boxes, dir, [])
      |> Enum.sort_by(fn {x, _y} -> x end)

    if p2 do
      boxes =
        affected
        |> Enum.reduce(boxes, fn pos, acc -> Map.delete(acc, pos) end)

      affected
      |> Enum.chunk_every(2)
      |> Enum.reduce(boxes, fn [lp, rp], acc ->
        acc
        |> Map.put(np(lp, dir), "[")
        |> Map.put(np(rp, dir), "]")
      end)
    else
      boxes =
        affected
        |> Enum.reduce(boxes, fn pos, acc -> Map.delete(acc, pos) end)

      affected
      |> Enum.reduce(boxes, fn pos, acc -> Map.put(acc, np(pos, dir), "O") end)
    end
  end

  def draw(robot, boxes, walls) do
    {sx, sy} = {30, 15}
    IO.puts("\n")

    Enum.each(0..sy, fn y ->
      Enum.map(0..sx, fn x ->
        cond do
          robot == {x, y} -> "@"
          Map.get(boxes, {x, y}, "_") == "O" -> "O"
          Map.get(boxes, {x, y}, "_") == "[" -> "["
          Map.get(boxes, {x, y}, "_") == "]" -> "]"
          Map.get(walls, {x, y}, "_") == "#" -> "#"
          true -> "."
        end
      end)
      |> Enum.join("")
      |> IO.puts()
    end)

    IO.puts("\n")
  end

  def collect_affected(pos = {x, y}, boxes, dir, affected) do
    case Map.get(boxes, pos, "_") do
      "O" ->
        collect_affected(np(pos, dir), boxes, dir, [pos | affected])

      "[" ->
        if dir == :up or dir == :down do
          collect_affected(np(pos, dir), boxes, dir, [pos | affected]) ++
            collect_affected(np({x + 1, y}, dir), boxes, dir, [{x + 1, y} | affected])
        else
          collect_affected(np(pos, dir), boxes, dir, [pos | affected])
        end

      "]" ->
        if dir == :up or dir == :down do
          collect_affected(np({x - 1, y}, dir), boxes, dir, [{x - 1, y} | affected]) ++
            collect_affected(np(pos, dir), boxes, dir, [pos | affected])
        else
          collect_affected(np(pos, dir), boxes, dir, [pos | affected])
        end

      "_" ->
        affected
    end
  end

  def can_move?(robot, boxes, walls, dir) do
    np = np(robot, dir)

    cond do
      Map.get(walls, np, "_") == "#" -> false
      Map.get(boxes, np, "_") == "_" -> true
      Map.get(boxes, np, "_") == "O" -> can_move?(np, boxes, walls, dir)
      Map.get(boxes, np, "_") == "[" -> can_move?(np, boxes, walls, dir)
      Map.get(boxes, np, "_") == "]" -> can_move?(np, boxes, walls, dir)
    end
  end

  def np({x, y}, :left), do: {x - 1, y}

  def np({x, y}, :right), do: {x + 1, y}

  def np({x, y}, :down), do: {x, y + 1}

  def np({x, y}, :up), do: {x, y - 1}

  def score(map) do
    map
    |> Enum.filter(fn {_, v} -> v == "O" or v == "[" end)
    |> Enum.map(fn {{x, y}, _} -> y * 100 + x end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day15/example.txt" |> Aoc.Day15.input2() |> Aoc.Day15.part2()
      9021
  """
  def part2({robot, boxes, walls, directions}) do
    {robot, boxes, walls, directions}
    |> step()
    |> score()
  end

  def input(filename) do
    [grid, com] =
      filename
      |> File.read!()
      |> String.split("\n\n", trim: true)

    directions =
      com
      |> String.replace("\n", "")
      |> String.split("", trim: true)
      |> Enum.map(fn c ->
        case c do
          ">" -> :right
          "<" -> :left
          "^" -> :up
          "v" -> :down
        end
      end)
      |> Enum.filter(fn x -> x != nil end)

    map =
      grid
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.split("", trim: true)
        |> Enum.with_index()
        |> Enum.map(fn {char, x} ->
          {{x, y}, char}
        end)
      end)
      |> Enum.into(%{})

    robot = Enum.find(map, fn {_, v} -> v == "@" end) |> elem(0)
    boxes = Enum.filter(map, fn {_, v} -> v == "O" end) |> Enum.into(%{})
    walls = Enum.filter(map, fn {_, v} -> v == "#" end) |> Enum.into(%{})

    {robot, boxes, walls, directions}
  end

  def input2(filename) do
    [grid, com] =
      filename
      |> File.read!()
      |> String.split("\n\n", trim: true)

    directions =
      com
      |> String.replace("\n", "")
      |> String.split("", trim: true)
      |> Enum.map(fn c ->
        case c do
          ">" -> :right
          "<" -> :left
          "^" -> :up
          "v" -> :down
          "\n" -> nil
        end
      end)
      |> Enum.filter(fn x -> x != nil end)

    map =
      grid
      |> String.split("\n", trim: true)
      |> Enum.with_index()
      |> Enum.flat_map(fn {line, y} ->
        line
        |> String.replace("#", "##")
        |> String.replace("O", "[]")
        |> String.replace(".", "..")
        |> String.replace("@", "@.")
        |> String.split("", trim: true)
        |> Enum.with_index()
        |> Enum.map(fn {char, x} ->
          {{x, y}, char}
        end)
      end)
      |> Enum.into(%{})

    robot = Enum.find(map, fn {_, v} -> v == "@" end) |> elem(0)
    boxes = Enum.filter(map, fn {_, v} -> v == "O" or v == "[" or v == "]" end) |> Enum.into(%{})
    walls = Enum.filter(map, fn {_, v} -> v == "#" end) |> Enum.into(%{})

    {robot, boxes, walls, directions}
  end
end
