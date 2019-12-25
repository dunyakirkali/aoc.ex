defmodule Aoc.Day22 do

  defmodule Pow do
    require Integer

    def pow(_, 0), do: 1
    def pow(x, n) when Integer.is_odd(n), do: x * pow(x, n - 1)
    def pow(x, n) do
      result = pow(x, div(n, 2))
      result * result
    end
  end

  defmodule Modular do
    def extended_gcd(a, b) do
      {last_remainder, last_x} = extended_gcd(abs(a), abs(b), 1, 0, 0, 1)
      {last_remainder, last_x * (if a < 0, do: -1, else: 1)}
    end

    defp extended_gcd(last_remainder, 0, last_x, _, _, _), do: {last_remainder, last_x}
    defp extended_gcd(last_remainder, remainder, last_x, x, last_y, y) do
      quotient   = div(last_remainder, remainder)
      remainder2 = rem(last_remainder, remainder)
      extended_gcd(remainder, remainder2, x, last_x - quotient*x, y, last_y - quotient*y)
    end

    def inverse(e, et) do
        {g, x} = extended_gcd(e, et)
        if g != 1, do: raise "The maths are broken!"
        rem(x+et, et)
    end
  end

  def part2(deck_size, filename) do
    # pand = rem(Aoc.Day22.Pow.pow(2020, 101741582076661), deck_size)
    # mia = Aoc.Day22.Modular.inverse(2020 - 1, deck_size)
    # rem((pand * X + (pand - 1) * mia * B), deck_size)
  end

  @doc """
      iex> Aoc.Day22.si({2, 7}, 3)
      {4, 9}

      iex> Aoc.Day22.si({2, 7}, 7)
      {6, 1}
  """
  def si({loc, mirror}, inc) do
    {loc, mirror}
  end

  @doc """
      iex> Aoc.Day22.sr({2, 7})
      {7, 2}
  """
  def sr({loc, mirror}) do
    {mirror, loc}
  end

  @doc """
      iex> Aoc.Day22.sc({2, 7}, 3, 10)
      {5, 0}

      iex> Aoc.Day22.sc({2, 7}, -4, 10)
      {8, 3}
  """
  def sc({loc, mirror}, n, size) do
    {rem(loc + n + size, size), rem(mirror + n + size, size)}
  end

  def part1(deck, filename) do
    parse_lines(deck, filename)
    |> Enum.find_index(fn x -> x == 2019 end)
  end

  @doc """
      iex> Aoc.Day22.parse_lines(0..9, "priv/day22/example_1.txt")
      [0, 3, 6, 9, 2, 5, 8, 1, 4, 7]

      iex> Aoc.Day22.parse_lines(0..9, "priv/day22/example_2.txt")
      [3, 0, 7, 4, 1, 8, 5, 2, 9, 6]

      iex> Aoc.Day22.parse_lines(0..9, "priv/day22/example_3.txt")
      [6, 3, 0, 7, 4, 1, 8, 5, 2, 9]

      iex> Aoc.Day22.parse_lines(0..9, "priv/day22/example_4.txt")
      [9, 2, 5, 8, 1, 4, 7, 0, 3, 6]
  """
  def parse_lines(deck, filename) do
    filename
    |> input()
    |> Enum.reduce(deck, fn line, acc ->
      parse(acc, line)
    end)
  end

  def parse(deck, line) do
    cond do
      String.match?(line, ~r/deal into new stack/) ->
        reverse(deck)
      String.match?(line, ~r/cut (-?\d+)/) ->
        [_, n] = Regex.run(~r/cut (-?\d+)/, line)
        cut(deck, String.to_integer(n))
      String.match?(line, ~r/deal with increment (-?\d+)/) ->
        [_, n] = Regex.run(~r/deal with increment (-?\d+)/, line)
        deal(deck, String.to_integer(n))
    end
  end

  @doc """
      iex> Aoc.Day22.reverse(0..9)
      [9, 8, 7, 6, 5, 4, 3, 2, 1, 0]
  """
  def reverse(list) do
    Enum.reverse(list)
  end

  @doc """
      iex> Aoc.Day22.cut(0..9, 3)
      [3, 4, 5, 6, 7, 8, 9, 0, 1, 2]

      iex> Aoc.Day22.cut(0..9, -4)
      [6, 7, 8, 9, 0, 1, 2, 3, 4, 5]
  """
  def cut(list, n) do
    {h, t} = Enum.split(list, n)
    t ++ h
  end

  @doc """
      iex> Aoc.Day22.deal(0..9, 3)
      [0, 7, 4, 1, 8, 5, 2, 9, 6, 3]

      iex> Aoc.Day22.deal(0..9, 7)
      [0, 3, 6, 9, 2, 5, 8, 1, 4, 7]
  """
  def deal(list, inc) do
    list_len = Enum.count(list)
    new_list = List.duplicate(-1, list_len)

    list
    |> Enum.with_index
    |> Enum.reduce(new_list, fn {x, index}, acc ->
      index = rem(inc * index, list_len)
      List.replace_at(acc, index, x)
    end)
  end

  defp input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
