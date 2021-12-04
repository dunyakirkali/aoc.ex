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
      |> Enum.zip_with(&Enum.frequencies/1)
      |> Enum.at(pos)

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
      |> Enum.zip_with(&Enum.frequencies/1)
      |> Enum.at(pos)

    bits
    |> Enum.filter(fn line ->
      Enum.at(line, pos) == if comp(bits_at_pos), do: "1", else: "0"
    end)
    |> oxygen_generator_rating(pos + 1)
  end

  defp lcb(matrix) do
    {rows, cols} = Nx.shape(matrix)

    bases = Nx.reverse(Nx.power(2, Nx.iota({cols})))

    matrix
    |> Nx.sum(axes: [0])
    |> Nx.less(div(rows, 2))
    |> Nx.dot(bases)
    |> Nx.to_scalar()
  end

  defp mcb(matrix) do
    {rows, cols} = Nx.shape(matrix)

    bases = Nx.reverse(Nx.power(2, Nx.iota({cols})))

    matrix
    |> Nx.sum(axes: [0])
    |> Nx.greater(div(rows, 2))
    |> Nx.dot(bases)
    |> Nx.to_scalar()
  end

  defp comp(freqs) do
    Map.get(freqs, "1") >= Map.get(freqs, "0")
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      Enum.map(String.to_charlist(line), & &1 - ?0)
    end)
    |> Nx.tensor()
  end
end
