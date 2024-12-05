defmodule Aoc.Day5 do
  @doc """
      iex> "priv/day5/example.txt" |> Aoc.Day5.input() |> Aoc.Day5.part1()
      143
  """
  def part1(list) do
    {rules, lists} = list

    lists
    |> Enum.filter(fn l ->
      valid?(l, rules)
    end)
    |> Enum.map(fn list -> center(list) end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day5/example.txt" |> Aoc.Day5.input() |> Aoc.Day5.part2()
      123
  """
  def part2(list) do
    {rules, lists} = list

    lists
    |> Enum.filter(fn l ->
      valid?(l, rules)
      |> Kernel.not()
    end)
    |> pmap(fn il ->
      il
      |> Comb.permutations()
      |> Stream.drop_while(fn comb ->
        not valid?(comb, rules)
      end)
      |> Enum.at(0)
    end)
    |> Enum.map(fn list -> center(list) end)
    |> Enum.sum()
  end

  defp center(l) do
    Enum.at(l, div(length(l), 2))
  end

  def pmap(collection, func) do
    collection
    |> Enum.map(&Task.async(fn -> func.(&1) end))
    |> Enum.map(fn x ->
      Task.await(x, 1_000_000_000)
    end)
  end

  defp valid?(l, rules) do
    l
    |> Stream.chunk_every(2, 1, :discard)
    |> Stream.map(fn [from, to] ->
      p = Graph.get_shortest_path(rules, from, to)

      p != nil and Enum.count(p) == 2
    end)
    |> Enum.all?()
  end

  def input(filename) do
    [h, t] =
      filename
      |> File.read!()
      |> String.split("\n\n", trim: true)

    rules =
      h
      |> String.split("\n", trim: true)
      |> Enum.map(fn l -> String.split(l, "|", trim: true) |> Enum.map(&String.to_integer/1) end)
      |> Enum.reduce(Graph.new(type: :directed), fn [from, to], acc ->
        Graph.add_edge(acc, from, to)
      end)

    procedure =
      t
      |> String.split("\n", trim: true)
      |> Enum.map(fn l -> String.split(l, ",", trim: true) |> Enum.map(&String.to_integer/1) end)

    {rules, procedure}
  end
end
