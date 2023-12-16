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
    start()

    map
    |> step({0, 0}, :right)

    ret = Agent.get(:energized, & &1)
    Agent.update(:energized, fn _ -> MapSet.new() end)

    ret
    |> Enum.map(fn tup -> elem(tup, 0) end)
    |> Enum.map(fn pos -> {pos, "#"} end)
    |> Enum.into(%{})
    |> Enum.count()
  end

  def pmap(collection, func) do
    collection
    |> Enum.map(&Task.async(fn -> func.(&1) end))
    |> Enum.map(&Task.await/1)
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
      IO.inspect(pos)
      start()

      step(map, pos, dir)

      ret = Agent.get(:energized, & &1)
      Agent.update(:energized, fn _ -> MapSet.new() end)

      ret
      |> Stream.map(fn tup -> elem(tup, 0) end)
      |> Stream.map(fn pos -> {pos, "#"} end)
      |> Enum.into(%{})
      |> Enum.count()
    end)
    |> Enum.max()
  end

  def step(map, pos, direction) do
    # IO.puts("")
    # IO.inspect(pos, label: "pos")

    energized =
      Agent.get(:energized, & &1)

    # |> IO.inspect()

    Agent.update(:energized, &MapSet.put(&1, {pos, direction}))
    nexts = tick(map, pos, direction)
    {width, height} = size(map)

    nexts
    |> Stream.filter(fn {{nx, ny}, _ndir} ->
      nx > -1 and ny > -1 and nx < width and ny < height
    end)
    |> Stream.filter(fn {pos, ndir} ->
      not MapSet.member?(energized, {pos, ndir})
    end)
    |> Enum.map(fn {npos, ndir} ->
      step(map, npos, ndir)
    end)
  end

  def tick(map, {x, y} = pos, direction) do
      cur = Map.get(map, pos, ".")
      # IO.inspect(cur, label: "cur")

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

  def row(map, r) do
    Enum.filter(map, fn {{_, y}, _} ->
      y == r
    end)
    |> Enum.into(%{})
  end

  def col(map, c) do
    Enum.filter(map, fn {{x, _}, _} ->
      x == c
    end)
    |> Enum.into(%{})
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
