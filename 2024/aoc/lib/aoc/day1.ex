defmodule Aoc.Day1 do
  @doc """
      iex> "priv/day1/example.txt" |> Aoc.Day1.input() |> Aoc.Day1.part1()
      11
  """
  def part1(list) do
    list
    |> lists()
    |> Enum.zip()
    |> Enum.map(fn {l, r} -> abs(l - r) end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day1/example.txt" |> Aoc.Day1.input() |> Aoc.Day1.part2()
      31
  """
  def part2(list) do
    [ll, rl] = lists(list)

    ll
    |> Enum.map(fn l ->
      rl
      |> Enum.count(fn x ->
        x == l
      end)
      |> Kernel.*(l)
    end)
    |> Enum.reduce(0, &(&1 + &2))
  end

  defp lists(list) do
    list
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
    |> Enum.map(&Enum.sort/1)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("   ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
  end
end
