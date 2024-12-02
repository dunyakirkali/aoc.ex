defmodule Aoc.Day2 do
  @doc """
      iex> "priv/day2/example.txt" |> Aoc.Day2.input() |> Aoc.Day2.part1()
      2
  """
  def part1(list) do
    list
    |> Enum.filter(&safe?/1)
    |> Enum.count()
  end

  def safe?(report) do
    steps =
      report
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [min, max] ->
        min - max
      end)

    inc =
      steps
      |> Enum.all?(&(&1 > 0))

    dec =
      steps
      |> Enum.all?(&(&1 < 0))

    step =
      steps
      |> Enum.map(fn x -> abs(x) end)
      |> Enum.all?(&(&1 >= 1 and &1 <= 3))

    (inc or dec) and step
  end

  @doc """
      iex> "priv/day2/example.txt" |> Aoc.Day2.input() |> Aoc.Day2.part2()
      4
  """
  def part2(list) do
    list
    |> Enum.filter(fn report ->
      report
      |> variate()
      |> Kernel.++([report])
      |> Enum.any?(&safe?/1)
    end)
    |> Enum.count()
  end

  def variate(list) do
    Enum.map(0..(length(list) - 1), fn index ->
      List.delete_at(list, index)
    end)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, " ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
