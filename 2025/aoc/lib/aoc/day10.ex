defmodule Aoc.Day10 do
  @doc """
      iex> "priv/day10/example.txt" |> Aoc.Day10.input() |> Aoc.Day10.part1()
      7
  """
  def part1(input) do
    input
    |> Enum.map(fn line ->
      count_min_press(line)
    end)
    |> Enum.sum()
  end

  @doc """
      iex> {[".", "#", "#", "."], [[0, 1], [0, 2], [2, 3], [2], [1, 3], [3]], [3, 5, 4, 7]} |> Aoc.Day10.count_min_press()
      2
      
      iex> {[".", ".", ".", "#", "."], [[1, 2, 3, 4], [0, 1, 2], [0, 4], [2, 3], [0, 2, 3, 4]], [7, 5, 12, 7, 2]} |> Aoc.Day10.count_min_press()
      3
  """
  def count_min_press({indicators, wiring, joltage}) do
    wiring
    |> Enum.count()
    |> generate()
    |> Enum.map(fn combination ->
      wiring
      |> Enum.with_index()
      |> Enum.filter(fn {_, i} ->
        Enum.at(combination, i) == 1
      end)
      |> Enum.map(fn {wires, _} -> wires end)
      |> then(fn w ->
        {Enum.count(w), List.flatten(w)}
      end)
    end)
    |> Enum.filter(fn {c, _} ->
      c != 0
    end)
    |> IO.inspect()
    |> Enum.map(fn {count, arr} ->
      {count,
       arr
       |> Enum.reduce(for(x <- 1..length(indicators), do: "."), fn c, acc ->
         case Enum.at(acc, c) do
           "#" -> List.replace_at(acc, c, ".")
           "." -> List.replace_at(acc, c, "#")
         end
       end)}
    end)
    |> Enum.filter(fn {_, x} ->
      x == indicators
    end)
    |> IO.inspect(label: "!")
    |> Enum.min_by(fn {c, _} -> c end)
    |> elem(0)
  end

  def generate(0), do: [[]]

  def generate(n) when n > 0 do
    for i <- 0..(2 ** n - 1) do
      Integer.to_string(i, 2)
      |> String.pad_leading(n, "0")
      |> String.graphemes()
      |> Enum.map(&String.to_integer/1)
    end
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [h | r] =
        line
        |> String.split(" ", trim: true)

      indicators =
        h
        |> String.graphemes()
        |> Enum.drop(-1)
        |> Enum.drop(1)

      [h | r] =
        r
        |> Enum.reverse()

      joltage =
        h
        |> String.graphemes()
        |> Enum.drop(-1)
        |> Enum.drop(1)
        |> Enum.join()
        |> String.split(",")
        |> Enum.map(&String.to_integer/1)

      wiring =
        r
        |> Enum.map(fn b ->
          b
          |> String.graphemes()
          |> Enum.drop(-1)
          |> Enum.drop(1)
          |> Enum.join()
          |> String.split(",")
          |> Enum.map(&String.to_integer/1)
        end)

      {indicators, wiring, joltage}
    end)
  end
end
