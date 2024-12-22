defmodule Aoc.Day22 do
  use Memoize

  @doc """
      iex> "priv/day22/example.txt" |> Aoc.Day22.input() |> Aoc.Day22.part1()
      37327623
  """
  def part1(codes) do
    codes
    |> Enum.map(fn code ->
      code
      |> generate(2000)
      |> List.last()
      |> elem(1)
    end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day22/example2.txt" |> Aoc.Day22.input() |> Aoc.Day22.part2()
      23
  """
  def part2(codes) do
    codes
    |> Enum.reduce(%{}, fn code, acc ->
      steps = generate(code, 2000)
      prices = prices(steps)
      changes = changes(prices)

      prices
      |> Enum.chunk_every(4, 1, :discard)
      |> Stream.with_index()
      |> Stream.map(fn {_, index} ->
        {index, Enum.slice(changes, index, 4) |> List.to_tuple()}
      end)
      |> Enum.reduce({MapSet.new(), acc}, fn {index, pattern}, {seen, acc} ->
        case MapSet.member?(seen, pattern) do
          true ->
            {seen, acc}

          false ->
            value = Enum.at(prices, index + 4, 0)

            {
              MapSet.put(seen, pattern),
              Map.update(acc, pattern, value, &(&1 + value))
            }
        end
      end)
      |> elem(1)
    end)
    |> Map.values()
    |> Enum.max()
  end

  @doc """
      iex> Aoc.Day22.changes([3, 0, 6, 5, 4, 4, 6, 4, 4, 2])
      [-3, 6, -1, -1, 0, 2, -2, 0, -2]
  """
  def changes(prices) do
    prices
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [a, b] -> b - a end)
  end

  @doc """
      iex> Aoc.Day22.prices([{0, 123}, {3, 15887950}, {6, 16495136}, {9, 527345}, {12, 704524}, {15, 1553684}, {18, 12683156}, {21, 11100544}, {24, 12249484}, {27, 7753432}, {30, 5908254}])
      [3, 0, 6, 5, 4, 4, 6, 4, 4, 2, 4]
  """
  def prices(series) do
    series
    |> Enum.map(fn num ->
      rem(elem(num, 1), 10)
    end)
  end

  @doc """
      iex> Aoc.Day22.generate(123, 10)
      [{0, 123}, {3, 15887950}, {6, 16495136}, {9, 527345}, {12, 704524}, {15, 1553684}, {18, 12683156}, {21, 11100544}, {24, 12249484}, {27, 7753432}, {30, 5908254}]
  """
  def generate(seed, n) do
    Stream.unfold({0, seed}, fn
      {index, sn} ->
        case rem(index, 3) do
          0 ->
            s1 = sn * 64
            ms1 = mix(sn, s1)
            nsn = prune(ms1)

            {{index, sn}, {index + 1, nsn}}

          1 ->
            s1 = div(sn, 32)
            ms1 = mix(sn, s1)
            nsn = prune(ms1)

            {{index, sn}, {index + 1, nsn}}

          2 ->
            s1 = sn * 2048
            ms1 = mix(sn, s1)
            nsn = prune(ms1)

            {{index, sn}, {index + 1, nsn}}
        end
    end)
    |> Stream.take_every(3)
    |> Enum.take(n + 1)
  end

  @doc """
      iex> Aoc.Day22.mix(15, 42)
      37
  """
  def mix(sn, value), do: Bitwise.bxor(value, sn)

  @doc """
      iex> Aoc.Day22.prune(100000000)
      16113920
  """
  def prune(sn), do: rem(sn, 16_777_216)

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end
end
