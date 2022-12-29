defmodule Aoc.Day24 do
  defmodule Chart do
    def new(data) do
      data
      |> String.split("\n", trim: true)
      |> Enum.drop(1)
      |> Enum.drop(-1)
      |> Enum.map(fn line ->
        line
        |> String.graphemes()
        |> Enum.drop(1)
        |> Enum.drop(-1)
      end)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {row, ri}, acc ->
        row
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {col, ci}, acc ->
          if col == " " do
            acc
          else
            Map.put(acc, {ci, ri}, ".")
          end
        end)
      end)
    end

    @doc """
        iex> map = Aoc.Day24.Chart.new("priv/day3/example.txt")
        ...> Aoc.Day24.Chart.size(map)
        {11, 11}

        iex> map = Aoc.Day24.Chart.new("priv/day3/input.txt")
        ...> Aoc.Day24.Chart.size(map)
        {31, 323}
    """
    def size(map) do
      {number_of_cols(map), number_of_rows(map)}
    end

    @doc """
        iex> map = Aoc.Day24.Chart.new("priv/day3/example.txt")
        ...> Aoc.Day24.Chart.number_of_rows(map)
        11

        iex> map = Aoc.Day24.Chart.new("priv/day3/input.txt")
        ...> Aoc.Day24.Chart.number_of_rows(map)
        323
    """
    def number_of_rows(map) do
      map
      |> Map.keys()
      |> Enum.map(fn x ->
        elem(x, 1)
      end)
      |> Enum.max()
      |> Kernel.+(1)
    end

    def blizzards(data) do
      data
      |> String.split("\n", trim: true)
      |> Enum.drop(1)
      |> Enum.drop(-1)
      |> Enum.map(fn line ->
        line
        |> String.graphemes()
        |> Enum.drop(1)
        |> Enum.drop(-1)
      end)
      |> Enum.with_index()
      |> Enum.reduce([], fn {row, ri}, acc ->
        row
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {col, ci}, acc ->
          if col == "#" or col == "." do
            acc
          else
            [{ci, ri, col} | acc]
          end
        end)
      end)
    end

    def number_of_cols(map) do
      map
      |> Map.keys()
      |> Enum.map(fn x ->
        elem(x, 0)
      end)
      |> Enum.max()
      |> Kernel.+(1)
    end

    def start(map) do
      c =
        map
        |> Map.keys()
        |> Enum.filter(fn {_, y} -> y == 0 end)
        |> Enum.map(fn x ->
          elem(x, 0)
        end)
        |> Enum.min()

      {c, 0}
    end

    def rows(chart, row) do
      chart
      |> Enum.filter(fn {{_, r}, _} ->
        r == row
      end)
    end

    def cols(chart, col) do
      chart
      |> Enum.filter(fn {{c, _}, _} ->
        c == col
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
          Map.get(map, {x, y}, ".")
        end)
        |> Enum.join("")
        |> IO.puts()
      end)

      IO.puts("\n")
      map
    end
  end

  def input(filename) do
    file = File.read!(filename)
    chart =
      file
      |> Aoc.Day24.Chart.new()
      |> Enum.map(fn {p, v} ->
        {p, List.wrap(v)}
      end)
      |> Enum.into(%{})

    blizzards =
      file
      |>Aoc.Day24.Chart.blizzards()

    {chart, blizzards}
  end

  @doc """
      iex> "priv/day24/example.txt" |> Aoc.Day24.input() |> Aoc.Day24.part1()
      10

      iex> "priv/day24/example2.txt" |> Aoc.Day24.input() |> Aoc.Day24.part1()
      18
  """
  def part1({chart, blizzards}) do
    sp = {0, -1}
    ep = {Aoc.Day24.Chart.number_of_cols(chart) - 1, find_end(chart)}
    solve(chart, sp, ep, blizzards)
  end

  def solve(chart, sp, ep, blizzards, t \\ 0) do
    queue = PriorityQueue.new() |> PriorityQueue.push({t, sp}, 0)
    visited = MapSet.new()
    {width, height} = Aoc.Day24.Chart.size(chart)

    try do
      traverse({chart, queue, visited, sp, ep, blizzards, width, height})
    catch
      time -> time
    end
  end

  def move(blizzards, t, {w, h}) do
    blizzards
    |> Enum.map(fn {c, r, dir} ->
      case dir do
        "^" -> {c, rem(r - t + 1000 * h, h)}
        "v" -> {c, rem(r + t, h)}
        ">" -> {rem(c + t, w), r}
        "<" -> {rem(c - t + 1000 * w, w), r}
      end
    end)
  end

  def traverse({chart, queue, visited, sp, ep, blizzards, width, height}) do
    {{:value, {time, cp}}, queue} = PriorityQueue.pop(queue)

    if MapSet.member?(visited, {time, cp}) do
      traverse({chart, queue, visited, sp, ep, blizzards, width, height})
    else
      visited = MapSet.put(visited, {time, cp})

      time = time + 1
      # |> IO.inspect()

      if cp == ep do
        throw(time - 1)
      else
        queue =
          cp
          |> neighbors()
          |> then(fn list ->
            list ++ [cp]
          end)
          |> Enum.filter(fn {nc, nr} = np ->
            np == sp or np == ep or (nc >= 0 and nr >= 0 and nc < width and nr < height)
          end)
          |> Enum.reject(fn point ->
            Enum.member?(move(blizzards, time, {width, height}), point)
          end)
          # |> dbg
          |> Enum.reduce(queue, fn np, queue ->
            PriorityQueue.push(queue, {time, np}, 0)
          end)

        traverse({chart, queue, visited, sp, ep, blizzards, width, height})
      end
    end
  end

  def debug(chart, blizzards, player) do
    blizzards
    |> Enum.reduce(chart, fn {bzc, bzr}, acc ->
      Map.put(acc, {bzc, bzr}, "x")
    end)
    |> Map.put(player, "E")
    |> Aoc.Day24.Chart.draw()
  end

  def neighbors({c, r}) do
    [{0, 1}, {1, 0}, {0, -1}, {-1, 0}]
    |> Enum.map(fn {dc, dr} ->
      {c + dc, r + dr}
    end)
  end

  def find_end(chart) do
    chart
    |> Map.keys()
    |> Enum.map(&elem(&1, 1))
    |> Enum.max()
    |> Kernel.+(1)
  end

  @doc """
      iex> "priv/day24/example2.txt" |> Aoc.Day24.input() |> Aoc.Day24.part2()
      54
  """
  def part2({chart, blizzards}) do
    sp = {0, -1}
    ep = {Aoc.Day24.Chart.number_of_cols(chart) - 1, find_end(chart)}
    one = solve(chart, sp, ep, blizzards)

    sp = {Aoc.Day24.Chart.number_of_cols(chart) - 1, find_end(chart)}
    ep = {0, -1}
    two = solve(chart, sp, ep, blizzards, one)

    sp = {0, -1}
    ep = {Aoc.Day24.Chart.number_of_cols(chart) - 1, find_end(chart)}
    three = solve(chart, sp, ep, blizzards, two)

    three
  end
end
