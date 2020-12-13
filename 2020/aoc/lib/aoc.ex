defmodule Aoc do
  # defmodule Ship do
  #   defstruct [pos: {0, 0}]
  # end
  # defmodule AGC do
  #   defstruct [:instructions, output: [], inputs: [], ip: 0, state: :cont, relative_base_offset: 0, score: 0]
  #
  #   def new(filename) do
  #     instructions = input(filename)
  #     memory = for _ <- 0..10_000_000, do: 0
  #     %AGC{instructions: instructions ++ memory}
  #   end
  # end

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

    def print(map) do
      maxY = number_of_rows(map)
      IEx.Helpers.clear()

      for(line <- 0..(maxY - 1), do: line)
      |> Enum.each(fn line ->
        map
        |> Enum.filter(fn {{_, y}, _} ->
          y == line
        end)
        |> Enum.map(fn {{_x, _y}, val} ->
          val
        end)
        |> IO.puts()
      end)

      map
    end
  end
end
