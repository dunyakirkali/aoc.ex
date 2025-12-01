defmodule Aoc.Day1 do
  @doc """
      iex> "priv/day1/example.txt" |> Aoc.Day1.input() |> Aoc.Day1.part1()
      3
  """
  def part1(list) do
    list
    |> Enum.reduce({50, 0}, fn {dir, amt}, {acc, cnt} ->
      turn(dir, amt, {acc, cnt})
    end)
    |> elem(1)
  end

  @doc """
      iex> Aoc.Day1.part2([right: 1000])
      10

      iex> Aoc.Day1.part2([left: 1000])
      10

      iex> "priv/day1/example.txt" |> Aoc.Day1.input() |> Aoc.Day1.part2()
      6
  """
  def part2(list) do
    list
    |> Enum.reduce({50, 0}, fn {dir, amt}, {acc, cnt} ->
      pass(dir, amt, {acc, cnt})
    end)
    |> elem(1)
  end

  defp pass(:left, 0, {position, acc}), do: {position, acc}

  defp pass(:left, amount, {position, acc}) when rem(position, 100) == 0,
    do: pass(:left, amount - 1, {-1, acc + 1})

  defp pass(:left, amount, {position, acc}), do: pass(:left, amount - 1, {position - 1, acc})

  defp pass(:right, 0, {position, acc}), do: {position, acc}

  defp pass(:right, amount, {position, acc}) when rem(position, 100) == 0,
    do: pass(:right, amount - 1, {1, acc + 1})

  defp pass(:right, amount, {position, acc}), do: pass(:right, amount - 1, {position + 1, acc})

  defp turn(:left, 0, {position, acc}) when rem(position, 100) == 0, do: {0, acc + 1}
  defp turn(:left, 0, {position, acc}), do: {position, acc}
  defp turn(:left, amount, {position, acc}), do: turn(:left, amount - 1, {position - 1, acc})

  defp turn(:right, 0, {position, acc}) when rem(position, 100) == 0, do: {0, acc + 1}
  defp turn(:right, 0, {position, acc}), do: {position, acc}
  defp turn(:right, amount, {position, acc}), do: turn(:right, amount - 1, {position + 1, acc})

  defp parse_turn(<<"L", rest::binary>>), do: {:left, String.to_integer(rest)}
  defp parse_turn(<<"R", rest::binary>>), do: {:right, String.to_integer(rest)}

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse_turn/1)
  end
end
