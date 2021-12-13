defmodule Aoc.Year2017.Day1 do
  @doc """
      iex> Aoc.Year2017.Day1.part1("priv/2017/day1/example_1.txt")
      3

      iex> Aoc.Year2017.Day1.part1("priv/2017/day1/example_2.txt")
      4

      iex> Aoc.Year2017.Day1.part1("priv/2017/day1/example_3.txt")
      0

      iex> Aoc.Year2017.Day1.part1("priv/2017/day1/example_4.txt")
      9
  """
  def part1(filename) do
    filename
    |> input()
    |> solve1()
  end

  @doc """
      iex> Aoc.Year2017.Day1.part2("priv/2017/day1/example_5.txt")
      6

      iex> Aoc.Year2017.Day1.part2("priv/2017/day1/example_6.txt")
      0

      iex> Aoc.Year2017.Day1.part2("priv/2017/day1/example_7.txt")
      4

      iex> Aoc.Year2017.Day1.part2("priv/2017/day1/example_8.txt")
      12

      iex> Aoc.Year2017.Day1.part2("priv/2017/day1/example_9.txt")
      4
  """
  def part2(filename) do
    digits = input(filename)

    len = round(length(digits) / 2)
    {h, t} = Enum.split(digits, len)

    digits
    |> Stream.zip(t ++ h)
    |> Stream.map(&Tuple.to_list/1)
    |> Stream.flat_map(&(&1))
    |> solve2()
  end

  defp solve2(digits) do
    digits
    |> Stream.chunk_every(2)
    |> Stream.filter(fn [lhs, rhs] -> lhs == rhs end)
    |> Stream.map(fn [lhs, _] -> lhs end)
    |> Enum.sum()
  end

  defp solve1(digits) do
    digits
    |> Stream.chunk_every(2, 1, [Enum.at(digits, 0)])
    |> Stream.filter(fn [lhs, rhs] -> lhs == rhs end)
    |> Stream.map(fn [lhs, _] -> lhs end)
    |> Enum.sum()
  end

  defp input(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.to_integer()
    |> Integer.digits()
  end

  def bench do
    Benchee.run(
      %{
        "Integer.digits" => fn ->
          input("priv/2017/day1/input.txt") |> String.to_integer() |> Integer.digits()
        end,
        "String.to_integer" => fn ->
          input("priv/2017/day1/input.txt") |> String.graphemes() |> Enum.map(&String.to_integer/1)
        end
      },
      formatters: [Benchee.Formatters.HTML, Benchee.Formatters.Console]
    )

    :ok
  end
end
