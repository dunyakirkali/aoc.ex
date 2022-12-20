defmodule Aoc.Day20 do
  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  @doc """
      iex> "priv/day20/example.txt" |> Aoc.Day20.input() |> Aoc.Day20.part1()
      3
  """
  def part1(numbers) do
    len = Enum.count(numbers)

    numbers
    |> CLL.init()
    |> do_mix(len, 0)
    |> CLL.to_list
    |> then(fn result ->
      zindex = Enum.find_index(result, fn x -> x == 0 end)

      [1000, 2000, 3000]
      |> Enum.map(fn index ->
        Enum.at(result, rem(zindex + index, len))
      end)
    end)
    |> Enum.sum()
  end

  def do_mix(cll, len, step) do

    # cll
    # |> CLL.to_list
    # |> IO.inspect()

    # offset = CLL.offset(cll) |> IO.inspect()

    if step == len do
      cll
    else
      k = CLL.value(cll) #|> IO.inspect(label: "k")
      cond do
        k == 0 ->
          cll
          |> CLL.next()
        k > 0 ->
          cll
          |> CLL.remove()
          |> CLL.next(rem(k, len - 1))
          |> CLL.insert(k)
        k < 0 ->
          cll
          |> CLL.remove()
          |> CLL.prev(rem(-k, len - 1))
          |> CLL.insert(k)
      end
      |> do_mix(len, step + 1)
    end
  end

  @doc """
      iex> "priv/day20/example.txt" |> Aoc.Day20.input() |> Aoc.Day20.part2()
      1623178306
  """
  def part2(numbers) do
    numbers = Enum.map(numbers, fn num -> 811_589_153 * num end)
    len = Enum.count(numbers)

    0..9
    |> Enum.reduce(CLL.init(numbers), fn inc, cll ->
      do_mix(cll, len, 0)
    end)
    |> CLL.to_list
    |> then(fn result ->
      zindex = Enum.find_index(result, fn x -> x == 0 end)

      [1000, 2000, 3000]
      |> Enum.map(fn index ->
        Enum.at(result, rem(zindex + index, len))
      end)
    end)
    |> Enum.sum()
  end
end
