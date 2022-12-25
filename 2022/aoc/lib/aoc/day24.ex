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
            Map.put(acc, {ci, ri}, col)
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

    @doc """
        iex> map = Aoc.Day24.Chart.new("priv/day3/example.txt")
        ...> Aoc.Day24.Chart.number_of_cols(map)
        11

        iex> map = Aoc.Day24.Chart.new("priv/day3/input.txt")
        ...> Aoc.Day24.Chart.number_of_cols(map)
        31
    """
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
          l = Map.get(map, {x, y}, ["."])

          if Enum.count(l) == 1 do
            List.first(l)
          else
            Enum.count(l)
          end
        end)
        |> Enum.join("")
        |> IO.puts()
      end)

      IO.puts("\n")
      map
    end
  end

  def input(filename) do
    filename
    |> File.read!()
    |> Aoc.Day24.Chart.new()
    |> Enum.map(fn {p, v} ->
      {p, List.wrap(v)}
    end)
    |> Enum.into(%{})
  end

  @doc """
      iex> "priv/day24/example.txt" |> Aoc.Day24.input() |> Aoc.Day24.part1()
      1
  """
  def part1(chart) do
    chart
    |> Aoc.Day24.Chart.draw()

    sp = {0, -1}
    ep = {Aoc.Day24.Chart.number_of_cols(chart) - 1, find_end(chart)}
    solve(chart, sp, ep)
  end

  def solve(chart, sp, ep) do
    bs = blizzards(chart)
    queue = PriorityQueue.new() |> PriorityQueue.push({0, sp}, 0)
    traverse({chart, queue, ep, bs})
  end

  def traverse({chart, queue, ep, bs}) do
    {{:value, {time, cp}}, queue} = PriorityQueue.pop(queue)

    time = time + 1

    if cp == ep do
      IO.inspect(time)
      exit("Complete")
    else
      cp
      |> neighbors()
      |> Enum.reduce({chart, queue, ep, bs}, &assess/2)
      |> traverse()
    end
  end

  def assess({cnp, rnp}, {chart, queue, ep, bs}) do
    # {cnp - }
    # {chart, PriorityQueue.push(queue, np), ep, bs}
  end

  def neighbors({c, r}) do
    [{0, -1}, {0, 1}, {1, 0}, {-1, 0}]
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

  def blizzards(chart) do
    chart
    |> Enum.filter(fn {_, l} ->
      Enum.any?(l, fn v ->
        Enum.member?(["^", "v", ">", "<"], v)
      end)
    end)
    |> Enum.map(fn x -> elem(x, 0) end)
    |> Enum.uniq()
  end

  # @doc """
  #     iex> "priv/day24/example.txt" |> Aoc.Day24.input() |> Aoc.Day24.part2()
  #     1
  # """
  # def part2(input) do
  #   input
  # end
end
