defmodule Aoc.Day9 do
  @doc """
      iex> inp = Aoc.Day9.input("priv/day9/example.txt")
      ...> Aoc.Day9.part1(inp, 5)
      127
  """
  def part1(inp, preamble) do
    inp
    |> Enum.chunk_every(preamble + 1, 1, :discard)
    |> Enum.reduce_while(0, fn set, acc ->
      csum = Enum.at(set, preamble)

      sums =
        set
        |> Enum.take(preamble)
        |> Combination.combine(2)
        |> Enum.map(fn comb ->
          Enum.sum(comb)
        end)

      if Enum.member?(sums, csum) do
        {:cont, acc}
      else
        {:halt, csum}
      end
    end)
  end

  @doc """
      iex> inp = Aoc.Day9.input("priv/day9/example.txt")
      ...> Aoc.Day9.part2(inp, 5)
      62
  """
  def part2(inp, preamble) do
    cs = part1(inp, preamble)

    inp
    |> find(2, cs)
  end

  def find(set, size, cs) do
    pos =
      set
      |> Enum.chunk_every(size, 1, :discard)
      |> Enum.map(fn op ->
        {op, Enum.sum(op)}
      end)

    if Enum.member?(Enum.map(pos, fn x -> elem(x, 1) end), cs) do
      sss =
        Enum.find(pos, fn x ->
          {_, tot} = x
          tot == cs
        end)

      min = Enum.min(elem(sss, 0))
      max = Enum.max(elem(sss, 0))
      min + max
    else
      find(set, size + 1, cs)
    end
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn row ->
      String.to_integer(row)
    end)
  end
end
