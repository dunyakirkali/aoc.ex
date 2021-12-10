defmodule Aoc.Day8 do
  @doc """
      iex> input = Aoc.Day8.input("priv/day8/example.txt")
      ...> Aoc.Day8.part1(input)
      0

      iex> input = Aoc.Day8.input("priv/day8/example2.txt")
      ...> Aoc.Day8.part1(input)
      26
  """
  def part1(input) do
    input
    |> Enum.map(fn {_, output} ->
      output
      |> Enum.map(fn digit ->
        MapSet.size(digit)
      end)
      |> Enum.filter(fn size ->
        Enum.member?([2, 4, 3, 7], size)
      end)
    end)
    |> List.flatten()
    |> Enum.count()
  end

  def figure_out(input, num) do
    Enum.filter(input, fn x ->
      MapSet.size(x) == num
    end)
  end

  @doc """
      iex> input = Aoc.Day8.input("priv/day8/example.txt")
      ...> Aoc.Day8.part2(input)
      5353

      iex> input = Aoc.Day8.input("priv/day8/example2.txt")
      ...> Aoc.Day8.part2(input)
      61229
  """
  def part2(input) do
    input
    |> Enum.map(fn {patterns, output} ->
      mapping = find_mapping(patterns)
      calculate(output, mapping)
    end)
    |> Enum.sum()
  end

  def find_mapping(patterns) do
    one = figure_out(patterns, 2) |> List.first()
    four = figure_out(patterns, 4) |> List.first()
    seven = figure_out(patterns, 3) |> List.first()
    eight = figure_out(patterns, 7) |> List.first()
    three = Enum.find(figure_out(patterns, 5), &(MapSet.size(MapSet.difference(&1, one)) == 3))

    five =
      Enum.find(
        figure_out(patterns, 5) -- [three],
        &(MapSet.size(MapSet.difference(&1, four)) == 2)
      )

    two = List.first(figure_out(patterns, 5) -- [three, five])
    nine = Enum.find(figure_out(patterns, 6), &(MapSet.size(MapSet.difference(&1, three)) == 1))

    six =
      Enum.find(
        figure_out(patterns, 6) -- [nine],
        &(MapSet.size(MapSet.difference(&1, one)) == 5)
      )

    zero = List.first(figure_out(patterns, 6) -- [nine, six])

    [zero, one, two, three, four, five, six, seven, eight, nine]
    |> Enum.map(&Enum.sort/1)
    |> Enum.zip(0..9)
    |> Enum.into(%{})
  end

  def calculate(output, mapping) do
    output
    |> Enum.map(fn digit ->
      digit(digit, mapping)
    end)
    |> Integer.undigits()
  end

  def digit(chars, mapping) do
    Map.get(mapping, Enum.sort(chars))
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.replace(" |\n", " | ")
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(" | ")
    end)
    |> Enum.map(fn [patterns, output] ->
      patterns =
        patterns
        |> String.split(" ", trim: true)
        |> Enum.map(fn y ->
          String.split(y, "", trim: true)
          |> MapSet.new()
        end)

      output =
        output
        |> String.split(" ", trim: true)
        |> Enum.map(fn y ->
          String.split(y, "", trim: true)
          |> MapSet.new()
        end)

      {patterns, output}
    end)
  end
end
