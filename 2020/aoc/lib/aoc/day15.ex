defmodule Aoc.Day15 do
  @max 2020
  @max2 30000000

  @doc """
      iex> Aoc.Day15.part1("0,3,6")
      436
  """
  def part1(inp) do
    inp
    |> String.split(",", trim: true)
    |> Enum.map(fn x ->
      String.to_integer(x)
    end)
    |> play(1, [], :first, @max)
    |> Enum.at(0)
  end

  def play([h | t], turn, seen, player, max) do
    play(t, turn + 1, [h | seen], player, max)
  end

  def play([], turn, seen, player, max) do
    play(0, turn + 1, [0 | seen], player, max)
  end

  def play(no, turn, seen, player, max) do
    if turn > max do
      seen
    else
      if Enum.count(seen, fn x -> x == no end) > 1 do
        [a, b] =
          seen
          |> Enum.reverse
          |> Enum.with_index
          |> Enum.filter(fn {x, ind} ->
            x == no
          end)
          |> Enum.take(-2)
          |> Enum.map(fn {_, ind} ->
            ind + 1
          end)

        new_no = b - a
        play(new_no, turn + 1, [new_no | seen], player, max)
      else
        play(0, turn + 1, [0 | seen], player, max)
      end
    end
  end

  @doc """
      iex> Aoc.Day15.part2("0,3,6")
      175594
  """
  def part2(inp) do
    inp
    |> String.split(",", trim: true)
    |> Enum.map(fn x ->
      String.to_integer(x)
    end)
    |> solve(@max2)
  end

  def solve(data, count) do
   Stream.iterate(
     {data
      |> Enum.with_index(1)
      |> Enum.into(%{}), 0, length(data) + 1},
     fn {history, next, turn} ->
       v = if prev = history[next], do: turn - prev, else: 0
       {Map.put(history, next, turn), v, turn + 1}
     end
   )
   |> Enum.at(count - length(data) - 1)
   |> elem(1)
 end
end
