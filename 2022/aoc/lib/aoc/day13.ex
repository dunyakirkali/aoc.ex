defmodule Aoc.Day13 do
  @doc """
      iex> "priv/day13/example.txt" |> Aoc.Day13.input() |> Aoc.Day13.part1()
      13
  """
  def part1(data) do
    data
    |> Enum.with_index(1)
    |> Enum.map(fn {[l, r], index} ->
      {compare(l, r), index}
    end)
    |> Enum.filter(fn {val, _} ->
      val == :lt
    end)
    |> Enum.map(&elem(&1, 1))
    |> Enum.sum()
  end

  def compare([h1 | l1], [h2 | l2]) when is_integer(h1) and is_integer(h2) do
    cond do
      h1 < h2 -> :lt
      h1 > h2 -> :gt
      true -> compare(l1, l2)
    end
  end

  def compare([h1 | l1], [h2 | l2]) when is_list(h1) and is_list(h2) do
    if (comp = compare(h1, h2)) == :eq do
      compare(l1, l2)
    else
      comp
    end
  end

  def compare([], [_ | _]) do
    :lt
  end

  def compare([_ | _], []) do
    :gt
  end

  def compare([], []) do
    :eq
  end

  def compare([h1 | l1], [h2 | l2])
      when is_list(h1) and is_integer(h2) do
    compare([h1 | l1], [[h2] | l2])
  end

  def compare([h1 | l1], [h2 | l2])
      when is_integer(h1) and is_list(h2) do
    compare([[h1] | l1], [h2 | l2])
  end

  @doc """
      iex> "priv/day13/example.txt" |> Aoc.Day13.input() |> Aoc.Day13.part2()
      140
  """
  def part2(data) do
    a = [[2]]
    b = [[6]]
    sorted = [a, b | Enum.flat_map(data, & &1)] |> Enum.sort(Aoc.Day13)

    [
      Enum.find_index(sorted, fn v -> v == a end) + 1,
      Enum.find_index(sorted, fn v -> v == b end) + 1
    ]
    |> Enum.product()
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn pair ->
      pair
      |> String.split("\n", trime: true)
      |> Enum.map(fn list ->
        list
        |> Code.eval_string()
        |> elem(0)
      end)
      |> Enum.reject(&is_nil/1)
    end)
  end
end
