defmodule Aoc.Day21 do
  @doc """
      iex> Aoc.Day21.part1({{4, 0}, {8, 0}, 0})
      739785
  """
  def part1(input) do
    Stream.iterate(0, &(&1 + 1))
    |> Stream.chunk_every(3, 3)
    |> Stream.with_index()
    |> Enum.reduce_while(input, fn {dice, roll}, {{pos_1, score_1}, {pos_2, score_2}, turn} ->
      dice = Enum.map(dice, fn die -> rem(die, 100) + 1 end)
      steps = Enum.sum(dice)

      if rem(turn, 2) == 0 do
        pos_1 = move(pos_1, steps)
        score_1 = score_1 + pos_1

        if score_1 >= 1000 do
          {:halt, [score_2, (roll + 1) * 3]}
        else
          {:cont, {{pos_1, score_1}, {pos_2, score_2}, turn + 1}}
        end
      else
        pos_2 = move(pos_2, steps)
        score_2 = score_2 + pos_2

        if score_2 >= 1000 do
          {:halt, [score_1, (roll + 1) * 3]}
        else
          {:cont, {{pos_1, score_1}, {pos_2, score_2}, turn + 1}}
        end
      end
    end)
    |> Enum.product()
  end

  @doc """
      iex> Aoc.Day21.move(7, 5)
      2
  """
  def move(pos, amount) do
    rem(pos - 1 + amount, 10) + 1
  end

  @doc """
      iex> Aoc.Day21.part2({{4, 0}, {8, 0}})
      444356092776315
  """
  def part2(input) do
    dice =
      for i <- 1..3, j <- 1..3, k <- 1..3 do
        i + j + k
      end
      |> Enum.frequencies()

    input
    |> play(dice)
    |> Tuple.to_list()
    |> Enum.max()
  end

  def play({{p1, s1}, {p2, s2}}, dice) do
    if s2 >= 21 do
      {0, 1}
    else
      for {d, n} <- dice, reduce: {0, 0} do
        {w1, w2} ->
          p = rem(p1 + d - 1, 10) + 1
          {v2, v1} = play({{p2, s2}, {p, s1 + p}}, dice)
          {w1 + v1 * n, w2 + v2 * n}
      end
    end
  end
end
