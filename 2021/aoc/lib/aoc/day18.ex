defmodule Aoc.Day18 do
  @doc """
      # iex> input = Aoc.Day18.input("priv/day18/example1.txt")
      # ...> Aoc.Day18.part1(input)
      # [[[[1,1],[2,2]],[3,3]],[4,4]]

      # iex> input = Aoc.Day18.input("priv/day18/example2.txt")
      # ...> Aoc.Day18.part1(input)
      # [[[[3,0],[5,3]],[4,4]],[5,5]]

      # iex> input = Aoc.Day18.input("priv/day18/example3.txt")
      # ...> Aoc.Day18.part1(input)
      # [[[[0,7],4],[[7,8],[6,0]]],[8,1]]

      # iex> input = Aoc.Day18.input("priv/day18/example4.txt")
      # ...> Aoc.Day18.part1(input)
      # 4140
  """
  def part1(list) do
    list
    |> sum()
    |> magnitude()
  end

  @doc """
      # iex> input = Aoc.Day18.input("priv/day18/example1.txt")
      # ...> Aoc.Day18.sum(input)
      # [[[[1,1],[2,2]],[3,3]],[4,4]]

      # iex> input = Aoc.Day18.input("priv/day18/example2.txt")
      # ...> Aoc.Day18.sum(input)
      # [[[[3,0],[5,3]],[4,4]],[5,5]]

      # iex> input = Aoc.Day18.input("priv/day18/example5.txt")
      # ...> Aoc.Day18.sum(input)
      # [[[[5,0],[7,4]],[5,5]],[6,6]]

      iex> input = Aoc.Day18.input("priv/day18/example6.txt")
      ...> Aoc.Day18.sum(input)
      [[[[8,7],[7,7]],[[8,6],[7,7]]],[[[0,7],[6,6]],[8,7]]]
  """
  def sum([h | t]) do
    t
    |> Enum.reduce(h, fn list, acc->
      add(acc, list)
      |> reduce()
    end)
  end

  def reduce(list) do
    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while(list, fn _, acc ->
      red =
        acc
        |> IO.inspect()
        |> explode()
        |> IO.inspect(label: "after explode")
        |> split()
        |> IO.inspect(label: "after split")
      if red == acc do
        {:halt, acc}
      else
        {:cont, red}
      end
    end)
  end

  @doc """
      # iex> input = Aoc.Day18.input("priv/day18/example.txt")
      # ...> Aoc.Day18.part1(input)
      # nil
  """
  def part2(_input) do
  end

  @doc """
      # iex> Aoc.Day18.explode([[[[[9,8],1],2],3],4])
      # [[[[0,9],2],3],4]

      # iex> Aoc.Day18.explode([7,[6,[5,[4,[3,2]]]]])
      # [7,[6,[5,[7,0]]]]

      # iex> Aoc.Day18.explode([[6,[5,[4,[3,2]]]],1])
      # [[6,[5,[7,0]]],3]

      # iex> Aoc.Day18.explode([[3,[2,[1,[7,3]]]],[6,[5,[4,[3,2]]]]])
      # [[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]]

      # iex> Aoc.Day18.explode([[3,[2,[8,0]]],[9,[5,[4,[3,2]]]]])
      # [[3,[2,[8,0]]],[9,[5,[7,0]]]]

      # iex> Aoc.Day18.explode([[[[[1, 1], [2, 2]], [3, 3]], [4, 4]], [5, 5]])
      # [[[[0, [3, 2]], [3, 3]], [4, 4]], [5, 5]]
  """
  def explode(list) do
    list
    |> do_explode(0)
    |> elem(0)
  end

  def do_explode([l, r], 4) do
    {0, [l, r]} |> IO.inspect()
  end
  def do_explode([l, r], _depth) when is_integer(l) and is_integer(r) do
    {[l, r], [0, 0]}
  end
  def do_explode([l, r], depth) when is_list(l) and is_integer(r) do
    {val, [sl, sr]} = do_explode(l, depth + 1)
    {[val, r + sr], [sl, 0]}
  end
  def do_explode([l, r], depth) when is_integer(l) and is_list(r) do
    {val, [sl, sr]} = do_explode(r, depth + 1)
    {[l + sl, val], [0, sr]}
  end
  def do_explode([l, r], depth) when is_list(l) and is_list(r) do
    case do_explode(l, depth + 1) do
      {vl, [0, 0]} ->
        {vr, [sl, sr]} = do_explode(r, depth + 1)
        {[vl, vr], [sl, sr]}
      {vl, [sl, sr]} ->
        {[vl, carry(r, [sl, sr])], [0, 0]}
    end
  end

  def carry([l, r], [_cl, cr]) when is_integer(l) and is_integer(r) do
    [l + cr, r]
  end
  def carry([l, r], [cl, cr]) when is_list(l) and is_integer(r) do
    [carry(l, [cl, cr]), r]
  end
  def carry([l, r], [_cl, cr]) when is_integer(l) and is_list(r) do
    [l + cr, r]
  end
  def carry([l, r], [cl, cr]) when is_list(l) and is_list(r) do
    [cl, cr]
  end

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
  def split([l, r]) when is_integer(l) and is_integer(r) do
    cond do
      l > 9 ->
        [split(l), r]
      r > 9 ->
        [l, split(r)]
      true ->
        [l, r]
    end
  end
  def split([l, r]) when is_integer(l) and is_list(r) do
    cond do
      l == split(l) ->
        [l, split(r)]
      true ->
        [split(l), r]
    end
  end
  def split([l, r]) when is_list(l) and is_integer(r) do
    [split(l), r]
  end
  def split([l, r]) when is_list(l) and is_list(r) do
    cond do
      l == split(l) ->
        [l, split(r)]
      true ->
        [split(l), r]
    end
  end
  def split(number) when is_integer(number) and number < 10 do
    number
  end
  def split(number) when is_integer(number) do
    division = number / 2

    [floor(division), ceil(division)]
  end

  @doc """
      iex> Aoc.Day18.add([1,2], [[3,4],5])
      [[1,2],[[3,4],5]]

      iex> Aoc.Day18.add([[[[4,3],4],4],[7,[[8,4],9]]], [1,1])
      [[[[[4,3],4],4],[7,[[8,4],9]]],[1,1]]
  """
  def add(snl, snr) do
    [snl, snr]
  end

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
    (3 * l) + (2 * r)
  end
  def magnitude([l, r]) when is_list(l) and is_list(r) do
    (3 * magnitude(l)) + (2 * magnitude(r))
  end
  def magnitude([l, r]) when is_list(l) and is_integer(r) do
    (3 * magnitude(l)) + (2 * r)
  end
  def magnitude([l, r]) when is_integer(l) and is_list(r) do
    (3 * l) + (2 * magnitude(r))
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
