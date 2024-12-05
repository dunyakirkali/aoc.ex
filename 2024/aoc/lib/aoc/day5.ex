defmodule Aoc.Day5 do
  @doc """
      iex> "priv/day5/example.txt" |> Aoc.Day5.input() |> Aoc.Day5.part1()
      143
  """
  def part1(list) do
    {rules, lists} = list

    lists
    |> Enum.filter(&valid?(rules, &1))

    # |> Enum.map(fn list -> center(list) end)
    # |> Enum.sum()
  end

  # @doc """
  #     iex> "priv/day5/example.txt" |> Aoc.Day5.input() |> Aoc.Day5.part2()
  #     123
  # """
  # def part2(list) do
  #   {rules, lists} = list

  #   lists
  #   |> Enum.filter(fn l ->
  #     valid?(l, rules)
  #     |> Kernel.not()
  #   end)
  #   |> pmap(fn il ->
  #     il
  #     |> Comb.permutations()
  #     |> Stream.drop_while(fn comb ->
  #       not valid?(comb, rules)
  #     end)
  #     |> Enum.at(0)
  #   end)
  #   |> Enum.map(fn list -> center(list) end)
  #   |> Enum.sum()
  # end

  defp center(l) do
    Enum.at(l, div(length(l), 2))
  end

  def valid?(_, []), do: true
  def valid?(rules, [x | xs]), do: Enum.all?(xs, fn y -> y in rules[x] end) and valid?(rules, xs)

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
