defmodule Aoc.Day16 do
  use Memoize

  @base [0, 1, 0, -1]

  @doc """
      # iex> Aoc.Day16.part2("priv/day16/example_1.txt", 100)
      # 84462026
      #
      # iex> Aoc.Day16.part2("priv/day16/example_2.txt", 100)
      # 78725270
      #
      # iex> Aoc.Day16.part2("priv/day16/example_3.txt", 100)
      # 53553731
  """
  def part2(filename, phases \\ 100) do
    inp = input(filename)

    res =
      inp
      |> List.duplicate(10_000)
      |> next(0, phases)

    offset = Enum.take(res, 7) |> Enum.join |> String.to_integer
    offsetted(res, offset)
  end

  @doc """
      iex> Aoc.Day16.offsetted([9,8,7,6,5,4,3,2,1,0,9,8,7,6,5,4,3,2,1,0], 7)
      21098765
  """
  def offsetted(list, offset) do
    list
    |> Enum.drop(offset)
    |> Enum.take(8)
    |> Enum.join
    |> String.to_integer
  end

  @doc """
      iex> Aoc.Day16.part1("priv/day16/example_0.txt", 1)
      48226158

      iex> Aoc.Day16.part1("priv/day16/example_0.txt", 2)
      34040438

      iex> Aoc.Day16.part1("priv/day16/example_0.txt", 3)
      03415518

      iex> Aoc.Day16.part1("priv/day16/example_0.txt", 4)
      01029498

      iex> Aoc.Day16.part1("priv/day16/example_1.txt", 100)
      24176176

      iex> Aoc.Day16.part1("priv/day16/example_2.txt", 100)
      73745418

      iex> Aoc.Day16.part1("priv/day16/example_3.txt", 100)
      52432133
  """
  def part1(filename, phases \\ 100) do
    filename
    |> input()
    |> next(0, phases)
    |> Enum.take(8)
    |> Enum.join
    |> String.to_integer
  end

  def next(inp, count, max) when count == max, do: inp
  def next(inp, count, max) do
    IO.puts("phase: #{count}")
    indexed = Stream.with_index(inp)
    indexed
    |> Enum.map(fn {_, char_index} ->
      Task.async(fn ->
        indexed
        |> Stream.map(fn {digit, digit_index} ->
          pattern = pattern_for(char_index) |> Stream.drop(1)
          digit * Enum.at(pattern, digit_index)
        end)
        |> Enum.sum
        |> Kernel.abs
        |> Kernel.rem(10)
      end)
    end)
    |> Enum.map(&Task.await/1)
    |> next(count + 1, max)
  end

  @doc """
      iex> Aoc.Day16.pattern_for(0) |> Enum.take(10)
      [0, 1, 0, -1, 0, 1, 0, -1, 0, 1]

      iex> Aoc.Day16.pattern_for(1) |> Enum.take(10)
      [0, 0, 1, 1, 0, 0, -1, -1, 0, 0]

      iex> Aoc.Day16.pattern_for(2) |> Enum.take(10)
      [0, 0, 0, 1, 1, 1, 0, 0, 0, -1]
  """
  defmemo pattern_for(index) do
    @base
    |> Stream.cycle()
    |> Stream.flat_map(fn x -> for _ <- 0..index, do: x end)
  end

  defp input(filename) do
    filename
    |> File.read!()
    |> String.trim
    |> String.to_charlist()
    |> Enum.map(&(&1 - ?0))
  end
end
