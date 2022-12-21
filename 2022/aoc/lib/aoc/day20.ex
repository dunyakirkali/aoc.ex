defmodule Aoc.Day20 do
  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.with_index()
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
    |> CLL.to_list()
    |> Enum.map(fn {value, _} -> value end)
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
    if step == len do
      cll
    else
      cll =
        Enum.reduce_while(Stream.iterate(0, &(&1 + 1)), CLL.reset(cll), fn _, acc ->
          {_, i} = CLL.value(acc)

          if i == step do
            {:halt, acc}
          else
            {:cont, CLL.next(acc)}
          end
        end)

      {k, i} = CLL.value(cll)

      cond do
        k == 0 ->
          cll

        k > 0 ->
          cll
          |> CLL.remove()
          |> CLL.next(rem(k, len - 1))
          |> CLL.insert({k, i})

        k < 0 ->
          cll
          |> CLL.remove()
          |> CLL.prev(rem(-k, len - 1))
          |> CLL.insert({k, i})
      end
      |> do_mix(len, step + 1)
    end
  end

  @doc """
      iex> "priv/day20/example.txt" |> Aoc.Day20.input() |> Aoc.Day20.part2()
      1623178306
  """
  def part2(numbers) do
    numbers = Enum.map(numbers, fn {val, ind} -> {811_589_153 * val, ind} end)
    len = Enum.count(numbers)

    0..9
    |> Enum.reduce(CLL.init(numbers), fn step, cll ->
      IO.inspect(step)
      do_mix(cll, len, 0)
    end)
    |> CLL.to_list()
    |> Enum.map(fn {value, _} -> value end)
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
