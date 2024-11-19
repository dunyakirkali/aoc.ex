defmodule Aoc.Day13 do
  @doc """
      iex> "priv/day13/example.txt" |> Aoc.Day13.input() |> Aoc.Day13.part1()
      405
  """
  def part1(list) do
    list
    |> Enum.flat_map(fn map ->
      [&find_vertical_mirror/2, &find_horizontal_mirror/2]
      |> Enum.map(fn func ->
        func.(map, false)
      end)
    end)
    |> Enum.filter(fn res ->
      res != {:error}
    end)
    |> collect([[], []])
    |> score()
  end

  def collect([], acc), do: acc
  def collect([{:horizontal, num} | t], [cols, rows]), do: collect(t, [cols, [num | rows]])
  def collect([{:vertical, num} | t], [cols, rows]), do: collect(t, [[num | cols], rows])

  def find_horizontal_mirror(map, part2) do
    {_, height} = size(map)

    do_find_horizontal_mirror(map, 0, 0, 1, height - 1, false, part2)
  end

  def do_find_horizontal_mirror(_, split, left, _, _, acc, part2) when left < 0,
    do: if(acc, do: {:horizontal, split + 1}, else: {:error})

  def do_find_horizontal_mirror(_, split, _, right, limit, acc, part2) when right > limit,
    do: if(acc, do: {:horizontal, split + 1}, else: {:error})

  def do_find_horizontal_mirror(map, split, left, right, limit, _, part2) do
    diff_count = compare_rows(row(map, left), row(map, right))

    if (part2 and diff_count == 1) or (!part2 and diff_count == 0) do
      do_find_horizontal_mirror(map, split, left - 1, right + 1, limit, true, part2)
    else
      do_find_horizontal_mirror(map, split + 1, split + 1, split + 2, limit, false, part2)
    end
  end

  def find_vertical_mirror(map, part2) do
    {width, _} = size(map)

    do_find_vertical_mirror(map, 0, 0, 1, width - 1, false, part2)
  end

  def do_find_vertical_mirror(_, split, left, _, _, acc, _part2) when left < 0,
    do: if(acc, do: {:vertical, split + 1}, else: {:error})

  def do_find_vertical_mirror(_, split, _, right, limit, acc, _part2) when right > limit,
    do: if(acc, do: {:vertical, split + 1}, else: {:error})

  def do_find_vertical_mirror(map, split, left, right, limit, _, part2) do
    diff_count =
      compare_cols(col(map, left), col(map, right))
      |> IO.inspect()

    if (part2 and diff_count == 1) or (!part2 and diff_count == 0) do
      do_find_vertical_mirror(map, split, left - 1, right + 1, limit, true, part2)
    else
      do_find_vertical_mirror(map, split + 1, split + 1, split + 2, limit, false, part2)
    end
  end

  @doc """
      iex> Aoc.Day13.score([[5], [4]])
      405
  """
  def score([cols, rows]) do
    cols
    |> Enum.sum()
    |> Kernel.+(100 * Enum.sum(rows))
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
      # iex> "priv/day13/example.txt" |> Aoc.Day13.input() |> Aoc.Day13.part2()
      # 400
  """
  def part2(list) do
    list
    |> Enum.flat_map(fn map ->
      [&find_vertical_mirror/2, &find_horizontal_mirror/2]
      |> Enum.map(fn func ->
        func.(map)
      end)
    end)
    |> Enum.filter(fn res ->
      res != {:error}
    end)
    |> collect([[], []])
    |> score()
  end

  def compare_cols(lm, rm) do
    ll =
      lm
      |> Enum.map(fn {{_, y}, _} -> y end)

    rl =
      rm
      |> Enum.map(fn {{_, y}, _} -> y end)

    Enum.reject(ll, &Enum.member?(rl, &1))
    |> Enum.count()
  end

  def compare_rows(lm, rm) do
    ll =
      lm
      |> Enum.map(fn {{x, _}, _} -> x end)

    rl =
      rm
      |> Enum.map(fn {{x, _}, _} -> x end)

    Enum.reject(ll, &Enum.member?(rl, &1))
    |> Enum.count()
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
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn piece ->
      piece
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
    end)
  end
end
