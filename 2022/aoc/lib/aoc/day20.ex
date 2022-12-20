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
	def right_rotate(l, n) when n > 0, do: Enum.reverse(l) |> left_rotate(n) |> Enum.reverse
	def right_rotate(l, n), do: left_rotate(l, -n)

  @doc """
      iex> "priv/day20/example.txt" |> Aoc.Day20.input() |> Aoc.Day20.part1()
      3
  """
  def part1(numbers) do
    len = Enum.count(numbers)
    indices = for x <- 0..len-1, do: x

    indices
    |> Enum.reduce({numbers, indices}, fn index, {numbers, indices} ->
      IO.puts("#{index/len}")
      location = Enum.find_index(indices, fn x -> x == index end)

      numbers = left_rotate(numbers, location)
      indices = left_rotate(indices, location)

      [number | numbers] = numbers
      [index | indices] = indices

      numbers = left_rotate(numbers, number)
      indices = left_rotate(indices, number)

      {[number | numbers], [index | indices]}# |> IO.inspect()

    end)
    |> elem(0)
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
