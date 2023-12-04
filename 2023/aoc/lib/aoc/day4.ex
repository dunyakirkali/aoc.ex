defmodule Aoc.Day4 do
  @doc """
      iex> "priv/day4/example.txt" |> Aoc.Day4.input() |> Aoc.Day4.part1()
      13
  """
  def part1(list) do
    Enum.map(list, fn {winning, numbers} ->
      MapSet.intersection(winning, numbers)
      |> Enum.count()
    end)
    |> Enum.filter(fn count ->
      count > 0
    end)
    |> Enum.map(fn count ->
      count
      |> then(fn count ->
        2 ** (count - 1)
      end)
    end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day4/example.txt" |> Aoc.Day4.input() |> Aoc.Day4.part2()
      30
  """
  def part2(list) do
    cards =
      list
      |> Enum.with_index()
      |> Enum.map(fn {v, i} ->
        {v, i + 1}
      end)

    cards_map =
      cards
      |> Enum.into(%{}, fn {thing, i} ->
        {i, {thing, i}}
      end)

    process(cards_map, cards, [])
    |> Enum.count()
  end

  def process(_, [], processed), do: processed

  def process(cards_map, [{{winning, numbers}, ind} = card | t], processed) do
    # processed |> IO.inspect(label: "processed")
    score =
      MapSet.intersection(winning, numbers)
      |> Enum.count()

    # |> IO.inspect(label: "score")

    if score == 0 do
      process(cards_map, t, [card | processed])
    else
      cards_to_add =
        1..score
        |> Enum.map(fn i ->
          Map.get(cards_map, i + ind)
        end)

      # |> IO.inspect(label: "cards_to_add")

      process(cards_map, t ++ cards_to_add, [card | processed])
    end
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [winning, numbers] =
        String.split(line, ~r/:\s+/)
        |> Enum.at(1)
        |> String.split(~r/\s+\|\s+/)
        |> Enum.map(fn part ->
          part
          |> String.split(~r/\s+/)
          |> Enum.map(fn num ->
            String.to_integer(num)
          end)
        end)

      {MapSet.new(winning), MapSet.new(numbers)}
    end)
  end
end
