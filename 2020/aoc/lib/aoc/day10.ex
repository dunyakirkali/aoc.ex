defmodule Aoc.Day10 do
  use Memoize

  @map_ones %{
    2 => 2,
    3 => 4,
    4 => 7
  }

  @doc """
      # iex> inp = Aoc.Day10.input("priv/day10/example.txt")
      # ...> Aoc.Day10.part1(inp)
      # 35
      #
      # iex> inp = Aoc.Day10.input("priv/day10/example2.txt")
      # ...> Aoc.Day10.part1(inp)
      # 220
  """
  def part1(inp) do
    {ones, _twos, threes} = calc(inp, 0, [], {0, 0, 0})
    ones * (threes + 1)
  end

  defmemo calc(inp, start, seen, {ones, twos, threes} = acc) do
    if Enum.count(seen) == Enum.count(inp) do
      acc
    else
      opts =
        inp
        |> Enum.filter(fn x ->
          x <= start + 3
        end)
        |> Kernel.--(seen)

      if Enum.count(opts) == 0 do
        nil
      else
        first =
          opts
          |> Enum.sort()
          |> Enum.at(0)

        acc =
          if first - start == 3 do
            {ones, twos, threes + 1}
          else
            acc
          end

        acc =
          if first - start == 2 do
            {ones, twos + 1, threes}
          else
            acc
          end

        acc =
          if first - start == 1 do
            {ones + 1, twos, threes}
          else
            acc
          end

        calc(inp, first, [first | seen], acc)
      end
    end
  end

  @doc """
      iex> inp = Aoc.Day10.input("priv/day10/example.txt")
      ...> Aoc.Day10.part2(inp)
      8

      iex> inp = Aoc.Day10.input("priv/day10/example2.txt")
      ...> Aoc.Day10.part2(inp)
      19208
  """
  def part2(inp) do
    last = List.last(inp)

    ([0 | inp] ++ [last + 3])
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] ->
      b - a
    end)
    |> Enum.reverse()
    |> Enum.chunk_by(fn v -> v == 1 end)
    |> Enum.reject(fn v -> v == [1] || Enum.all?(v, &(&1 == 3)) end)
    |> Enum.map(&length/1)
    |> Enum.map(fn x ->
      Map.get(@map_ones, x, 1)
    end)
    |> Enum.filter(fn x ->
      x != nil
    end)
    |> Enum.reduce(1, fn x, acc ->
      acc * x
    end)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      String.to_integer(row)
    end)
    |> Enum.sort()
  end
end
