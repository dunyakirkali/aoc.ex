defmodule Aoc.Day19 do
  use Memoize

  @doc """
      iex> "priv/day19/example.txt" |> Aoc.Day19.input() |> Aoc.Day19.part1()
      6
  """
  def part1({d, p}) do
    {d, p}

    d
    |> Enum.map(fn design ->
      search(design, p, "")
    end)
    |> Enum.reject(&(&1 == false))
    |> Enum.count()
  end

  @doc """
      iex> "priv/day19/example.txt" |> Aoc.Day19.input() |> Aoc.Day19.part2()
      16
  """
  def part2({d, p}) do
    d
    |> Enum.map(&find_all_arrangements(&1, p))
    |> Enum.sum()
  end

  defmemo(find_all_arrangements("", _towels), do: 1)

  defmemo find_all_arrangements(pattern, towels) do
    count =
      towels
      |> Enum.filter(&String.starts_with?(pattern, &1))
      |> Enum.map(fn towel ->
        remaining = String.slice(pattern, String.length(towel)..-1//1)
        find_all_arrangements(remaining, towels)
      end)
      |> Enum.sum()

    count
  end

  def search(design, patterns, acc \\ "") do
    Enum.any?(patterns, fn pattern ->
      np = acc <> pattern

      cond do
        np == design -> true
        String.starts_with?(design, np) -> search(design, patterns, np)
        true -> false
      end
    end)
  end

  def input(filename) do
    [p, d] =
      filename
      |> File.read!()
      |> String.split("\n\n", trim: true)

    designs =
      d
      |> String.split("\n", trim: true)

    patterns =
      p
      |> String.split(", ", trim: true)

    {designs, patterns}
  end
end
