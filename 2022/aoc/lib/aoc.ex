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

  defmodule Chart do
    def new(data) do
      data
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        String.graphemes(line)
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
      size = size(map) |> IO.inspect()

      Enum.each(0..elem(size, 1), fn y ->
        Enum.map(0..elem(size, 0), fn x ->
          Map.get(map, {x, y}, " ")
        end)
        |> Enum.join("")
        |> IO.puts()
      end)

      IO.puts("\n")
      map
    end
  end
end
