defmodule Aoc.Day18 do
  @doc """
      iex> input = Aoc.Day18.input("priv/day18/example4.txt")
      ...> Aoc.Day18.part1(input)
      4140
  """
  def part1(input) do
    input
    |> Enum.reduce(&add(&2, &1))
    |> magnitude()
  end

  @doc """
      iex> input = Aoc.Day18.input("priv/day18/example4.txt")
      ...> Aoc.Day18.part2(input)
      3993
  """
  def part2(input) do
    for a <- input, b <- input, a != b do
      [
        magnitude(add(a, b)),
        magnitude(add(b, a))
      ]
    end
    |> List.flatten()
    |> Enum.max()
  end

  def add(a, b), do: reduce([a, b])

  def reduce(l) do
    cond do
      l = explode(l, _level = 1) ->
        {_, l, _} = l
        reduce(l)

      l = split(l) ->
        reduce(l)

      true ->
        l
    end
  end

  def merge([a, b], n), do: [a, merge(b, n)]
  def merge(n, [a, b]), do: [merge(n, a), b]
  def merge(a, b), do: a + b

  @doc """
      iex> Aoc.Day18.explode([[[[[9,8],1],2],3],4], 1)
      {9, [[[[0, 9], 2], 3], 4], 0}

      iex> Aoc.Day18.explode([7,[6,[5,[4,[3,2]]]]], 1)
      {0, [7, [6, [5, [7, 0]]]], 2}

      iex> Aoc.Day18.explode([[6,[5,[4,[3,2]]]],1], 1)
      {0, [[6, [5, [7, 0]]], 3], 0}

      iex> Aoc.Day18.explode([[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]], 1)
      {0, [[3, [2, [8, 0]]], [9, [5, [4, [3, 2]]]]], 0}

      iex> Aoc.Day18.explode([[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]], 1)
      {0, [[3, [2, [8, 0]]], [9, [5, [7, 0]]]], 2}

      iex> Aoc.Day18.explode([[[[[1, 1], [2, 2]], [3, 3]], [4, 4]], [5, 5]], 1)
      {1, [[[[0, [3, 2]], [3, 3]], [4, 4]], [5, 5]], 0}
  """
  def explode([l, r], 5) do
    {l, 0, r}
  end

  def explode([l, r], level) do
    with {ll, n, lr} <- explode(l, level + 1) do
      {ll, [n, merge(lr, r)], 0}
    end ||
      with {rl, n, rr} <- explode(r, level + 1) do
        {0, [merge(l, rl), n], rr}
      end
  end

  def explode(_n, _level), do: false

  @doc """
      iex> Aoc.Day18.split([10, 0])
      [[5, 5], 0]

      iex> Aoc.Day18.split([11, 0])
      [[5, 6], 0]

      iex> Aoc.Day18.split([0, 12])
      [0, [6, 6]]

      iex> Aoc.Day18.split([[[[0,7],4],[15,[0,13]]],[1,1]])
      [[[[0,7],4],[[7,8],[0,13]]],[1,1]]

      iex> Aoc.Day18.split([[[[0,7],4],[[7,8],[0,13]]],[1,1]])
      [[[[0,7],4],[[7,8],[0,[6,7]]]],[1,1]]
  """
  def split([l, r]) do
    if sl = split(l) do
      [sl, r]
    else
      if sr = split(r) do
        [l, sr]
      else
        false
      end
    end
  end

  def split(number) when number >= 10 do
    division = number / 2
    [floor(division), ceil(division)]
  end

  def split(number) when is_integer(number) and number < 10, do: false

  @doc """
      iex> Aoc.Day18.magnitude([9,1])
      29

      iex> Aoc.Day18.magnitude([[1,2],[[3,4],5]])
      143

      iex> Aoc.Day18.magnitude([[[[0,7],4],[[7,8],[6,0]]],[8,1]])
      1384

      iex> Aoc.Day18.magnitude([[[[1,1],[2,2]],[3,3]],[4,4]])
      445

      iex> Aoc.Day18.magnitude([[[[3,0],[5,3]],[4,4]],[5,5]])
      791

      iex> Aoc.Day18.magnitude([[[[5,0],[7,4]],[5,5]],[6,6]])
      1137

      iex> Aoc.Day18.magnitude([[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]])
      3488

      iex> Aoc.Day18.magnitude([[[[6,6],[7,6]],[[7,7],[7,0]]],[[[7,7],[7,7]],[[7,8],[9,9]]]])
      4140
  """
  def magnitude([l, r]) when is_integer(l) and is_integer(r) do
    3 * l + 2 * r
  end

  def magnitude([l, r]) when is_list(l) and is_list(r) do
    3 * magnitude(l) + 2 * magnitude(r)
  end

  def magnitude([l, r]) when is_list(l) and is_integer(r) do
    3 * magnitude(l) + 2 * r
  end

  def magnitude([l, r]) when is_integer(l) and is_list(r) do
    3 * l + 2 * magnitude(r)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      {result, _} = Code.eval_string(line)
      result
    end)
  end
end
