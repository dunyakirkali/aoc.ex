defmodule Aoc.Day25 do
  @doc """
      iex> inp = Aoc.Day25.input("priv/day25/example.txt")
      ...> Aoc.Day25.part1(inp)
      14897079
  """
  def part1(input) do
    [key1, key2] = Enum.map(input, &String.to_integer/1)
    loop_size2 = loop_size(key2)
    transform(key1, loop_size2)
  end

  defp loop_size(public_key) do
    loop_size(1, public_key, 1)
  end

  defp loop_size(value, public_key, size) do
    subject = 7

    case transform_one(value, subject) do
      ^public_key ->
        size

      value ->
        loop_size(value, public_key, size + 1)
    end
  end

  defp transform(subject, size) do
    transform(1, subject, size)
  end

  defp transform(value, _subject, 0), do: value

  defp transform(value, subject, size) do
    transform(transform_one(value, subject), subject, size - 1)
  end

  defp transform_one(value, subject) do
    rem(value * subject, 20_201_227)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
