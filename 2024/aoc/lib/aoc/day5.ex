defmodule Aoc.Day5 do
  @doc """
      iex> "priv/day5/example.txt" |> Aoc.Day5.input() |> Aoc.Day5.part1()
      143
  """
  def part1(list) do
    {rules, lists} = list

    lists
    |> Enum.filter(&valid?(rules, &1))
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
      valid?(rules, l)
      |> Kernel.not()
    end)
    |> Enum.map(fn l -> sort(rules, l) end)
    |> Enum.map(fn list -> center(list) end)
    |> Enum.sum()
  end

  defp center(l) do
    Enum.at(l, div(length(l), 2))
  end

  def sort(_, []), do: []

  def sort(rules, current) do
    next = Enum.find(current, fn x -> current -- Map.get(rules, x, []) == [x] end)
    [next | sort(rules, List.delete(current, next))]
  end

  defp valid?(_, []), do: true

  defp valid?(rules, [x | xs]),
    do: Enum.all?(xs, fn y -> y in Map.get(rules, x, []) end) and valid?(rules, xs)

  def input(filename) do
    [h, t] =
      filename
      |> File.read!()
      |> String.split("\n\n", trim: true)

    rules =
      h
      |> String.split("\n", trim: true)
      |> Enum.map(fn l -> String.split(l, "|", trim: true) |> Enum.map(&String.to_integer/1) end)
      |> Enum.group_by(fn [key, _] -> key end, fn [_, value] -> value end)

    procedure =
      t
      |> String.split("\n", trim: true)
      |> Enum.map(fn l -> String.split(l, ",", trim: true) |> Enum.map(&String.to_integer/1) end)

    {rules, procedure}
  end
end
