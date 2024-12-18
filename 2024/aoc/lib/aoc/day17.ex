defmodule Aoc.Day17 do
  use Bitwise

  @doc """
      iex> {%{"C" => 9}, [2, 6]} |> Aoc.Day17.part1()
      {%{"B" => 1, "C" => 9}, 2, []}

      iex> {%{"A" => 10}, [5,0,5,1,5,4]} |> Aoc.Day17.part1()
      {%{"A" => 10}, 6, [0, 1, 2]}

      iex> {%{"A" => 2024}, [0,1,5,4,3,0]} |> Aoc.Day17.part1()
      {%{"A" => 0}, 6, [4,2,5,6,7,7,7,7,3,1,0]}

      iex> {%{"B" => 29}, [1,7]} |> Aoc.Day17.part1()
      {%{"B" => 26}, 2, []}

      iex> {%{"B" => 2024, "C" => 43690}, [4,0]} |> Aoc.Day17.part1()
      {%{"B" => 44354, "C" => 43690}, 2, []}

      iex> "priv/day17/example.txt" |> Aoc.Day17.input() |> Aoc.Day17.part1()
      {%{"A" => 0, "B" => 0, "C" => 0}, 6, [4, 6, 3, 5, 6, 3, 5, 2, 1, 0]}
  """
  def part1({registers, program}) do
    Stream.iterate(1, &(&1 + 1))
    |> Enum.reduce_while([program, {registers, 0, []}], fn _, [program, {registers, ip, out}] ->
      op = Enum.at(program, ip)

      if op == nil do
        {:halt, {registers, ip, out}}
      else
        v = Enum.at(program, ip + 1)
        {:cont, [program, op(op, v, registers, ip, out)]}
      end
    end)
  end

  @doc """
      iex> {%{"A" => 2024, "B" => 0, "C" => 0}, [0,3,5,4,3,0]} |> Aoc.Day17.part2()
      117440
  """
  def part2({registers, program}) do
    program
    |> Enum.reverse()
    |> Enum.map(fn dest ->
      Enum.find(0..7, fn i ->
        left = Bitwise.bxor(Bitwise.bxor(i, 3), 5)
        right = trunc(div(i, 2 ** Bitwise.bxor(i, 3)))

        Bitwise.bxor(left, right) == dest
      end)
    end)
    |> Enum.map(fn i -> to_3_bit_list(i) end)
    |> Enum.reduce(0, fn bit, acc -> (acc <<< 1) + bit end)
  end

  def to_3_bit_list(n) when n >= 0 and n < 8 do
    for i <- 2..0, do: Bitwise.band(Bitwise.bsr(n, i), 1)
  end

  def combo(v, _registers) when v >= 0 and v <= 3, do: v
  def combo(4, registers), do: Map.get(registers, "A")
  def combo(5, registers), do: Map.get(registers, "B")
  def combo(6, registers), do: Map.get(registers, "C")
  def combo(7, _registers), do: raise("Invalid register")

  @doc """
      iex> Aoc.Day17.op(0, 2, %{"A" => 40}, 2, [])
      {%{"A" => 10}, 4, []}
  """
  def op(0, v, registers, ip, out) do
    {Map.put(registers, "A", trunc(Map.get(registers, "A") / 2 ** combo(v, registers))), ip + 2,
     out}
  end

  def op(1, v, registers, ip, out) do
    {Map.put(registers, "B", Bitwise.bxor(Map.get(registers, "B"), v)), ip + 2, out}
  end

  def op(2, v, registers, ip, out) do
    {Map.put(registers, "B", rem(combo(v, registers), 8)), ip + 2, out}
  end

  def op(3, v, registers, ip, out) do
    if Map.get(registers, "A") == 0 do
      {registers, ip + 2, out}
    else
      {registers, v, out}
    end
  end

  def op(4, _v, registers, ip, out) do
    {Map.put(registers, "B", Bitwise.bxor(Map.get(registers, "B"), Map.get(registers, "C"))),
     ip + 2, out}
  end

  def op(5, v, registers, ip, out) do
    {registers, ip + 2, out ++ [rem(combo(v, registers), 8)]}
  end

  def op(6, v, registers, ip, out) do
    {Map.put(registers, "B", trunc(Map.get(registers, "A") / 2 ** combo(v, registers))), ip + 2,
     out}
  end

  def op(7, v, registers, ip, out) do
    {Map.put(registers, "C", trunc(Map.get(registers, "A") / 2 ** combo(v, registers))), ip + 2,
     out}
  end

  def input(filename) do
    [registers, program] =
      filename
      |> File.read!()
      |> String.split("\n\n", trim: true)

    registers =
      registers
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        %{"name" => rn, "value" => rv} =
          Regex.named_captures(~r/Register (?<name>.*): (?<value>.*)/, line)

        {rn, String.to_integer(rv)}
      end)
      |> Enum.into(%{})

    %{"x" => pieces} = Regex.named_captures(~r/Program: (?<x>.*)/, program)

    pieces = pieces |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1)

    {registers, pieces} |> IO.inspect()
  end
end
