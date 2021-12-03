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

  defp co2_scrubber_rating([bits], _), do: Enum.join(bits) |> String.to_integer(2)

  defp co2_scrubber_rating(bits, pos) do
    bits_at_pos =
      bits
      |> Enum.map(fn x ->
        Enum.at(x, pos)
      end)

    bits
    |> Enum.filter(fn line ->
      Enum.at(line, pos) == if comp(bits_at_pos), do: "0", else: "1"
    end)
    |> co2_scrubber_rating(pos + 1)
  end

  defp oxygen_generator_rating([bits], _), do: Enum.join(bits) |> String.to_integer(2)

  defp oxygen_generator_rating(bits, pos) do
    bits_at_pos =
      bits
      |> Enum.map(fn x ->
        Enum.at(x, pos)
      end)

    bits
    |> Enum.filter(fn line ->
      Enum.at(line, pos) == if comp(bits_at_pos), do: "1", else: "0"
    end)
    |> oxygen_generator_rating(pos + 1)
  end

  defp lcb(bits) do
    len = Enum.count(Enum.at(bits, 0))

    bits
    |> Enum.reduce(%{}, fn line, acc ->
      Enum.reduce(0..(len - 1), acc, fn bi, acc ->
        Map.update(acc, bi, [Enum.at(line, bi)], fn existing_value ->
          [Enum.at(line, bi) | existing_value]
        end)
      end)
    end)
    |> Enum.sort_by(fn {k, _} -> k end)
    |> Enum.map(fn {_, line} ->
      if comp(line), do: "0", else: "1"
    end)
    |> Enum.join()
    |> String.to_integer(2)
  end

  defp mcb(bits) do
    len = Enum.count(Enum.at(bits, 0))

    bits
    |> Enum.reduce(%{}, fn line, acc ->
      Enum.reduce(0..(len - 1), acc, fn bi, acc ->
        Map.update(acc, bi, [Enum.at(line, bi)], fn existing_value ->
          [Enum.at(line, bi) | existing_value]
        end)
      end)
    end)
    |> Enum.sort_by(fn {k, _} -> k end)
    |> Enum.map(fn {_, line} ->
      if comp(line), do: "1", else: "0"
    end)
    |> Enum.join()
    |> String.to_integer(2)
  end

  defp comp(bits) do
    Enum.count(bits, fn x -> x == "1" end) >= Enum.count(bits, fn x -> x == "0" end)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      String.split(x, "", trim: true)
    end)
  end
end
