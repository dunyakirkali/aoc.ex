defmodule Aoc.Day25 do
  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
  end

  @doc """
      iex> "priv/day25/example.txt" |> Aoc.Day25.input() |> Aoc.Day25.part1()
      "2=-1=0"
  """
  def part1(input) do
    input
    |> Enum.map(&to_integer/1)
    |> Enum.sum()
    |> to_snafu()
  end

  @doc """
      iex> Aoc.Day25.to_integer("1")
      1

      iex> Aoc.Day25.to_integer("2")
      2

      iex> Aoc.Day25.to_integer("1=")
      3

      iex> Aoc.Day25.to_integer("1-")
      4

      iex> Aoc.Day25.to_integer("1-")
      4

      iex> Aoc.Day25.to_integer("2=-01")
      976
  """
  def to_integer(snafu) do
    snafu
    |> String.to_charlist()
    |> Enum.reverse()
    |> do_to_integer([])
    |> Enum.reverse()
    |> Enum.with_index()
    |> to_decimal(0)
  end

  @doc """
      iex> Aoc.Day25.to_snafu(976)
      "2=-01"
  """
  def to_snafu(integer) do
    integer
    |> do_to_snafu()
    |> Enum.reverse()
    |> List.to_string()
  end

  defp do_to_snafu(integer) when integer == 0, do: ''

  defp do_to_snafu(integer) do
    char =
      case rem(integer + 2, 5) do
        0 -> ?=
        1 -> ?-
        2 -> ?0
        3 -> ?1
        4 -> ?2
      end

    [char | do_to_snafu(div(integer + 2, 5))]
  end

  defp to_decimal([], acc), do: acc

  defp to_decimal([{hv, hi} | t], acc) do
    acc = 5 ** hi * hv + acc
    to_decimal(t, acc)
  end

  defp do_to_integer([], acc), do: acc

  defp do_to_integer([h | t], acc) do
    acc =
      case h do
        ?= -> [-2 | acc]
        ?- -> [-1 | acc]
        ?0 -> [0 | acc]
        ?1 -> [1 | acc]
        ?2 -> [2 | acc]
      end

    do_to_integer(t, acc)
  end
end
