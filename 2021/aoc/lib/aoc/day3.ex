defmodule Aoc.Day3 do
  @doc """
      iex> input = Aoc.Day3.input("priv/day3/example.txt")
      ...> Aoc.Day3.part1(input)
      198
  """
  def part1(input) do
    mcb(input) * lcb(input)
  end

  @doc """
      iex> input = Aoc.Day3.input("priv/day3/example.txt")
      ...> Aoc.Day3.part2(input)
      230
  """
  def part2(input) do
    oxygen_generator_rating(input, 0) * co2_scrubber_rating(input, 0)
  end

  defp co2_scrubber_rating(input, _) when length(input) == 1,
    do: List.first(input) |> String.to_integer(2)

  defp co2_scrubber_rating(input, pos) do
    bits =
      input
      |> Enum.map(fn x ->
        String.split(x, "", trim: true)
      end)

    fbits =
      bits
      |> Enum.map(fn x ->
        Enum.at(x, pos)
      end)

    mcbf =
      if Enum.count(fbits, fn x -> x == "1" end) >= Enum.count(fbits, fn x -> x == "0" end) do
        "0"
      else
        "1"
      end

    bits
    |> Enum.filter(fn line ->
      Enum.at(line, pos) == mcbf
    end)
    |> Enum.map(fn x ->
      Enum.join(x)
    end)
    |> co2_scrubber_rating(pos + 1)
  end

  defp oxygen_generator_rating(input, _) when length(input) == 1,
    do: List.first(input) |> String.to_integer(2)

  defp oxygen_generator_rating(input, pos) do
    bits =
      input
      |> Enum.map(fn x ->
        String.split(x, "", trim: true)
      end)

    fbits =
      bits
      |> Enum.map(fn x ->
        Enum.at(x, pos)
      end)

    mcbf =
      if Enum.count(fbits, fn x -> x == "1" end) >= Enum.count(fbits, fn x -> x == "0" end) do
        "1"
      else
        "0"
      end

    bits
    |> Enum.filter(fn line ->
      Enum.at(line, pos) == mcbf
    end)
    |> Enum.map(fn x ->
      Enum.join(x)
    end)
    |> oxygen_generator_rating(pos + 1)
  end

  defp lcb(input) do
    bits =
      input
      |> Enum.map(fn x ->
        String.split(x, "", trim: true)
      end)

    len = Enum.count(Enum.at(bits, 0))

    bits
    |> Enum.reduce(%{}, fn line, acc ->
      Enum.reduce(0..(len - 1), acc, fn bi, acc ->
        Map.update(acc, bi, [Enum.at(line, bi)], fn existing_value ->
          [Enum.at(line, bi) | existing_value]
        end)
      end)
    end)
    |> Enum.sort_by(fn {k, v} -> k end)
    |> Enum.map(fn {k, line} ->
      line

      if Enum.count(line, fn x -> x == "1" end) > div(Enum.count(line), 2) do
        "0"
      else
        "1"
      end
    end)
    |> Enum.join()
    |> String.to_integer(2)
  end

  defp mcb(input) do
    bits =
      input
      |> Enum.map(fn x ->
        String.split(x, "", trim: true)
      end)

    len = Enum.count(Enum.at(bits, 0))

    bits
    |> Enum.reduce(%{}, fn line, acc ->
      Enum.reduce(0..(len - 1), acc, fn bi, acc ->
        Map.update(acc, bi, [Enum.at(line, bi)], fn existing_value ->
          [Enum.at(line, bi) | existing_value]
        end)
      end)
    end)
    |> Enum.sort_by(fn {k, v} -> k end)
    |> Enum.map(fn {k, line} ->
      line

      if Enum.count(line, fn x -> x == "1" end) > div(Enum.count(line), 2) do
        "1"
      else
        "0"
      end
    end)
    |> Enum.join()
    |> String.to_integer(2)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
