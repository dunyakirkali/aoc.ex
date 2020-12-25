defmodule Aoc.Day25 do
  @doc """
      iex> Aoc.Day25.part1(5764801, 17807724)
      14897079
  """
  def part1(card, door, limit \\ 100) do
    [{_, cls}] =
      1..limit
      |> Stream.map(fn i ->
        {{7, i}, transform(1, 7, i)}
      end)
      |> Stream.drop_while(fn {_, acc} -> acc != card end)
      |> Stream.map(fn {{i, j}, _} ->
        {i, j}
      end)
      |> Stream.take(1)
      |> Enum.to_list()

    transform(1, door, cls) |> IO.inspect(label: "Solution")
  end

  @doc """
      iex> Aoc.Day25.transform(1, 7, 8)
      5764801

      iex> Aoc.Day25.transform(1, 7, 11)
      17807724
  """
  def transform(value, _subject, 0) do
    value
  end

  def transform(value, subject, loop_size) do
    value
    |> Kernel.*(subject)
    |> rem(20_201_227)
    |> transform(subject, loop_size - 1)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
