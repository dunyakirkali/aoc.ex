defmodule Aoc.Day6 do
  @doc """
      iex> "priv/day6/example.txt" |> Aoc.Day6.input() |> Aoc.Day6.part1()
      4277556
  """
  def part1({nums, cals}) do
    {nums, cals}

    nums
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.zip()
    |> Enum.with_index()
    |> Enum.map(fn {tuple, i} ->
      tuple
      |> Tuple.to_list()
      |> Enum.reduce(fn x, acc ->
        case Enum.at(cals, i) do
          "*" -> acc * x
          "+" -> acc + x
        end
      end)
    end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day6/example.txt" |> Aoc.Day6.input() |> Aoc.Day6.part2()
      3263827
  """
  def part2({nums, cals}) do
    {nums, cals}

    len = length(cals)

    nums
    |> Enum.map(fn line ->
      line
      |> String.graphemes()
      |> Enum.map(fn x ->
        case x do
          " " -> 0
          v -> String.to_integer(v)
        end
      end)
      |> Enum.chunk_every(len)
      |> pad_with_zeros()
      |> Enum.map(fn list ->
        Enum.slice(list, 0, length(list) - 1)
      end)
    end)
    |> combine
    |> Enum.with_index()
    |> Enum.map(fn {tuple, i} ->
      tuple
      |> IO.inspect()
      |> Enum.map(&drop_trailing_zeros/1)
      |> Enum.reduce(fn x, acc ->
        case Enum.at(cals, i) do
          "*" -> acc * x
          "+" -> acc + x
        end
      end)
    end)
    |> Enum.sum()
  end

  def drop_trailing_zeros(n) when is_integer(n) do
    n
    |> Integer.to_string()
    |> String.trim_trailing("0")
    |> case do
      "" -> "0"
      s -> s
    end
    |> String.to_integer()
  end

  def combine(rows) do
    # rows is a list of lists of triples

    num_cols =
      rows
      |> List.first()
      |> length()

    num_positions =
      rows
      |> List.first()
      |> hd()
      |> length()

    for col <- 0..(num_cols - 1) do
      for pos <- 0..(num_positions - 1) do
        rows
        |> Enum.map(fn row -> Enum.at(row, col) |> Enum.at(pos) end)
        |> Enum.join()
        |> String.to_integer()
      end
    end
  end

  def pad_with_zeros(lists) do
    max_len = lists |> Enum.map(&length/1) |> Enum.max()

    Enum.map(lists, fn list ->
      zeros_to_add = max_len - length(list)
      list ++ List.duplicate(0, zeros_to_add)
    end)
  end

  def input(filename) do
    list =
      filename
      |> File.read!()
      |> String.split("\n", trim: true)

    cals =
      List.last(list)
      |> String.split(" ", trim: true)

    nums =
      Enum.slice(list, 0, length(list) - 1)

    {nums, cals}
  end
end
