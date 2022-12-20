defmodule Aoc.Day20 do
  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)

    # |> Enum.reduce(Deque.new(10_000), fn val, acc ->
    #   Deque.append(acc, val)
    # end)
  end

	def left_rotate(l, n \\ 1)
	def left_rotate([], _), do: []
	def left_rotate(l, 0), do: l
	def left_rotate([h | t], 1), do: t ++ [h]
	def left_rotate(l, n) when n > 0, do: left_rotate(left_rotate(l, 1), n-1)
	def left_rotate(l, n), do: right_rotate(l, -n)

	def right_rotate(l, n \\ 1)
	def right_rotate(l, n) when n > 0, do: Enum.reverse(l) |> ListRotation.left_rotate(n) |> Enum.reverse
	def right_rotate(l, n), do: left_rotate(l, -n)

  @doc """
      iex> "priv/day20/example.txt" |> Aoc.Day20.input() |> Aoc.Day20.part1()
      3
  """
  def part1(numbers) do
    len = Enum.count(numbers)

    numbers
    |> Enum.reduce(numbers, fn num, acc ->
      cond do
        num == 0 ->
          acc

        num < 0 ->
          acc = Enum.reverse(acc)
          index = Enum.find_index(acc, fn x -> x == num end)
          to = rem(index - num + 1, len)
          acc = Enum.slide(acc, index, to)
          Enum.reverse(acc)

        num > 0 ->
          index = Enum.find_index(acc, fn x -> x == num end)
          to = rem(index + num, len)
          Enum.slide(acc, index, to)
      end
      |> IO.inspect()
    end)
    |> then(fn result ->
      zindex = Enum.find_index(result, fn x -> x == 0 end)

      [1000, 2000, 3000]
      |> Enum.map(fn index ->
        Enum.at(result, rem(zindex + index, len))
      end)
    end)
    |> Enum.sum()
  end

  # @doc """
  #     iex> "priv/day20/example.txt" |> Aoc.Day20.input() |> Aoc.Day20.part2()
  #     3472
  # """
  # def part2(blueprints) do
  #   blueprints
  #   |> Enum.take(3)
  #   |> Aoc.Parallel.pmap(&solve(&1, 32))
  #   |> Enum.reduce(1, fn x, acc -> x * acc end)
  # end
end
