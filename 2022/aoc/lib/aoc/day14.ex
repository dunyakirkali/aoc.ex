defmodule Aoc.Day14 do
  @doc """
      iex> "priv/day14/example.txt" |> Aoc.Day14.input() |> Aoc.Day14.part1()
      24
  """
  def part1(data) do
    map = new(data)
    lowest = lowest(map)

    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while({map, {500, 0}}, fn _, {m, {sx, sy}} ->
      {m, result} = move_sand(m, {sx, sy})

      return =
        case result do
          {nsx, nsy} -> {m, {nsx, nsy}}
          :rest -> {m, {500, 0}}
        end

      if sy == lowest do
        {:halt, m}
      else
        {:cont, return}
      end
    end)
    |> then(fn map ->
      # draw(map)
      map
    end)
    |> Enum.count(fn {_, v} ->
      v == "o"
    end)
  end

  def new(ins) do
    ins
    |> Enum.reduce(%{}, fn runs, acc ->
      runs
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.reduce(acc, fn [[fx, fy], [tx, ty]], acc ->
        for x <- fx..tx, y <- fy..ty, into: acc, do: {{x, y}, "#"}
      end)
    end)
  end

  def move_sand(map, {x, y}) do
    cond do
      Map.get(map, {x, y + 1}, ".") == "." ->
        map =
          map
          |> Map.put({x, y}, ".")
          |> Map.put({x, y + 1}, "s")

        {map, {x, y + 1}}

      Map.get(map, {x - 1, y + 1}, ".") == "." ->
        map =
          map
          |> Map.put({x, y}, ".")
          |> Map.put({x - 1, y + 1}, "s")

        {map, {x - 1, y + 1}}

      Map.get(map, {x + 1, y + 1}, ".") == "." ->
        map =
          map
          |> Map.put({x, y}, ".")
          |> Map.put({x + 1, y + 1}, "s")

        {map, {x + 1, y + 1}}

      true ->
        map =
          map
          |> Map.put({x, y}, "o")

        {map, :rest}
    end
  end

  def calc(map) do
    map
    |> Enum.filter(fn _, val ->
      val == "o"
    end)
    |> Enum.count()
  end

  def draw(map) do
    size = size(map)

    Enum.each(0..elem(size, 1), fn y ->
      Enum.map(0..elem(size, 0), fn x ->
        Map.get(map, {x, y}, ".")
      end)
      |> Enum.join("")
      |> IO.puts()
    end)

    map
  end

  def lowest(map) do
    map
    |> Enum.map(fn {{_, y}, _} ->
      y
    end)
    |> Enum.max()
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

  @doc """
      iex> "priv/day14/example.txt" |> Aoc.Day14.input() |> Aoc.Day14.part2()
      93
  """
  def part2(data) do
    map = new(data)
    lowest = lowest(map)

    map =
      0..1_000
      |> Enum.to_list()
      |> Enum.reduce(map, fn x, acc ->
        Map.put(acc, {x, lowest + 2}, "#")
      end)

    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while({map, {500, 0}}, fn _, {m, {sx, sy}} ->
      {m, result} = move_sand(m, {sx, sy})

      return =
        case result do
          {nsx, nsy} -> {m, {nsx, nsy}}
          :rest -> {m, {500, 0}}
        end

      if sx == 500 and sy == 0 and Map.get(m, {sx, sy}) == "o" do
        {:halt, m}
      else
        {:cont, return}
      end
    end)
    |> then(fn map ->
      # draw(map)
      map
    end)
    |> Enum.count(fn {_, v} ->
      v == "o"
    end)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn path ->
      path
      |> String.split(" -> ", trim: true)
      |> Enum.map(fn steps ->
        steps
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
    end)
  end
end
