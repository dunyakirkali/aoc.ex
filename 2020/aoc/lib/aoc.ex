defmodule Aoc do
  defmodule Parallel do
    def pmap(collection, func) do
      collection
      |> Enum.map(&Task.async(fn -> func.(&1) end))
      |> Enum.map(fn x ->
        Task.await(x, 1_000_000_000)
      end)
    end
  end

  defmodule Point do
    defstruct x: 0, y: 0, z: 0

    @doc """
        iex> from = %Aoc.Point{x: -3, y: 5, z: -4}
        ...> to = %Aoc.Point{x: 2, y: -2, z: 3}
        ...> Aoc.Point.manhattan(from, to)
        19

        iex> from = %Aoc.Point{x: -3, y: 5}
        ...> to = %Aoc.Point{x: 2, y: -2}
        ...> Aoc.Point.manhattan(from, to)
        12
    """
    def manhattan(from, to) do
      abs(from.x - to.x) + abs(from.y - to.y) + abs(from.z - to.z)
    end
  end

  defmodule Chart do
    def new(filename) do
      filename
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        String.graphemes(line)
      end)
      |> Enum.with_index()
      |> Enum.reduce(%{}, fn {row, ri}, acc ->
        row
        |> Enum.with_index()
        |> Enum.reduce(acc, fn {col, ci}, acc ->
          Map.put(acc, {ci, ri}, col)
        end)
      end)
    end

    def row(chart, rn) do
      chart
      |> Enum.filter(fn {{x, y}, val} ->
        y == rn
      end)
      |> Enum.sort_by(fn {{x, y}, val} ->
        x
      end)
      |> Enum.map(fn {{x, y}, val} ->
        val
      end)
    end

    def col(chart, cn) do
      chart
      |> Enum.filter(fn {{x, y}, val} ->
        x == cn
      end)
      |> Enum.sort_by(fn {{x, y}, val} ->
        y
      end)
      |> Enum.map(fn {{x, y}, val} ->
        val
      end)
      |> Enum.reverse()
    end

    @doc """
        iex> map = Aoc.Chart.new("priv/day3/example.txt")
        ...> Aoc.Chart.size(map)
        {11, 11}

        iex> map = Aoc.Chart.new("priv/day3/input.txt")
        ...> Aoc.Chart.size(map)
        {31, 323}
    """
    def size(map) do
      {number_of_cols(map), number_of_rows(map)}
    end

    @doc """
        iex> map = Aoc.Chart.new("priv/day3/example.txt")
        ...> Aoc.Chart.number_of_rows(map)
        11

        iex> map = Aoc.Chart.new("priv/day3/input.txt")
        ...> Aoc.Chart.number_of_rows(map)
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
        iex> map = Aoc.Chart.new("priv/day3/example.txt")
        ...> Aoc.Chart.number_of_cols(map)
        11

        iex> map = Aoc.Chart.new("priv/day3/input.txt")
        ...> Aoc.Chart.number_of_cols(map)
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
  end
end
