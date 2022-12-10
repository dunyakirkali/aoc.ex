defmodule Aoc.Day10 do
  @doc """
      iex> "priv/day10/example.txt" |> Aoc.Day10.input() |> Aoc.Day10.part1()
      13140
  """
  def part1(moves) do
    moves
    |> run()
    |> elem(3)
    |> Enum.reverse()
    |> Enum.filter(fn {step, _} ->
      Enum.member?([20, 60, 100, 140, 180, 220], step)
    end)
    |> Enum.map(fn {s, x} ->
      s * x
    end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day10/example.txt" |> Aoc.Day10.input() |> Aoc.Day10.part2()
      :ok
  """
  def part2(moves) do
    IO.write("\n")
    moves
    |> run()
    |> elem(3)
    |> Enum.reverse()
    |> Enum.chunk_every(40)
    |> Enum.reduce(:ok, fn chunk, acc ->
      chunk
      |> Enum.reduce(acc, fn {step, x}, acc ->
        if(Enum.member?([x - 1, x, x + 1], rem(step - 1, 40))) do
          IO.write("#")
        else
          IO.write(".")
        end

        acc
      end)

      IO.write("\n")
      acc
    end)
  end

  def run(moves) do
    Stream.unfold(0, fn
      241 -> nil
      n -> {n, n + 1}
    end)
    |> Enum.to_list()
    |> Enum.reduce({%{x: 1}, -1, moves, []}, fn step, {regs, dur, moves, collect} ->
      if moves == [] do
        {
          regs,
          dur,
          moves,
          collect
        }
      else
        [cur_mov | rem_mov] = moves
        rec = {step, regs[:x]}
        collect = [rec | collect]

        case dur do
          -1 ->
            {
              regs,
              duration(cur_mov),
              moves,
              collect
            }

          0 ->
            {
              execute(cur_mov, regs),
              duration(cur_mov),
              rem_mov,
              collect
            }

          _ ->
            {
              regs,
              dur - 1,
              moves,
              collect
            }
        end
      end
    end)
  end

  def duration(move) do
    case move do
      :noop -> 0
      {:addx, _} -> 1
    end
  end

  def execute(move, regs) do
    case move do
      :noop -> regs
      {:addx, amount} -> Map.update!(regs, :x, &(&1 + amount))
    end
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      cond do
        line == "noop" ->
          :noop

        String.starts_with?(line, "addx") ->
          ["addx", amount] = String.split(line, " ", trim: true)
          {:addx, String.to_integer(amount)}
      end
    end)
  end
end
