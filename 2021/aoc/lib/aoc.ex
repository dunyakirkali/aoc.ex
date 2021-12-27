defmodule Aoc do
  defmodule Zobrist do
    def table(cells, pieces) do
      for cell <- cells,
          piece <- pieces,
          into: %{} do
        # {{cell, piece}, System.unique_integer([:positive, :monotonic])}
        <<n::64>> = :crypto.strong_rand_bytes(8)
        {{cell, piece}, n}
      end
    end

    def hash(table, [move]), do: Map.get(table, move)

    def hash(table, moves) do
      moves
      |> Enum.map(fn move ->
        Map.get(table, move)
      end)
      |> Enum.reduce(0, fn move, acc ->
        Bitwise.bxor(acc, move)
      end)
    end
  end

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
          Map.put(acc, {ci, ri}, String.to_integer(col))
        end)
      end)
    end

    def row(chart, rn) do
      chart
      |> Enum.filter(fn {{_, y}, _} ->
        y == rn
      end)
      |> Enum.sort_by(fn {{x, _}, _} ->
        x
      end)
      |> Enum.map(fn {_, val} ->
        val
      end)
    end

    def col(chart, cn) do
      chart
      |> Enum.filter(fn {{x, _}, _} ->
        x == cn
      end)
      |> Enum.sort_by(fn {{_, y}, _} ->
        y
      end)
      |> Enum.map(fn {_, val} ->
        val
      end)
      |> Enum.reverse()
    end

    def size(map) do
      {number_of_cols(map), number_of_rows(map)}
    end

    def neighbors({x, y}) do
      [
        {x - 1, y - 1},
        {x, y - 1},
        {x + 1, y - 1},
        {x - 1, y},
        {x + 1, y},
        {x - 1, y + 1},
        {x, y + 1},
        {x + 1, y + 1}
      ]
    end

    def number_of_rows(map) do
      map
      |> Map.keys()
      |> Enum.map(fn x ->
        elem(x, 1)
      end)
      |> Enum.max()
      |> Kernel.+(1)
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

    def print(map) do
      IO.puts("")

      Enum.map(0..9, fn row ->
        Enum.map(0..9, fn col ->
          pos = {col, row}

          case map do
            %{^pos => 0} ->
              IO.ANSI.format([:red, "0", :reset])

            %{^pos => value} ->
              IO.ANSI.format([:green, to_string(value), :reset])
          end
        end)
        |> Enum.intersperse(" ")
      end)
      |> Enum.join("\n")
      |> IO.puts()
    end
  end
end
