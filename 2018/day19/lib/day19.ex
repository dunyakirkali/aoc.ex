defmodule Day19 do
  use Memoize

  @moduledoc """
  Documentation for Day19.
  """
  
  def part_2(filename) do
    ip_bind = ip_bind(filename)
    registers = [1, 0, 0, 0, 0, 0]
    instructions = instructions(filename)
    
    0..200
    |> Enum.reduce({0, registers}, fn _, {ip, registers} ->
      instruction = Enum.at(instructions, ip)
      step({ip, registers}, instruction, ip_bind)
    end)
    |> elem(1)
    |> List.last()
    |> divisor()
    |> Enum.sum()
  end
  
  def divisor(n), do: divisor(n, 1, []) |> Enum.sort

  defp divisor(n, i, factors) when n < i*i    , do: factors
  defp divisor(n, i, factors) when n == i*i   , do: [i | factors]
  defp divisor(n, i, factors) when rem(n,i)==0, do: divisor(n, i+1, [i, div(n,i) | factors])
  defp divisor(n, i, factors)                 , do: divisor(n, i+1, factors)
  
  def part_1(filename) do
    ip_bind = ip_bind(filename)
    registers = [1, 0, 0, 0, 0, 0]
    instructions = instructions(filename)
    
    0..999_999_999_999
    |> Enum.reduce_while({0, registers}, fn _, {ip, registers} ->
      IO.inspect(registers)
      if ip >= length(instructions) do
        {:halt, {ip, registers}}
      else
        instruction = Enum.at(instructions, ip)
        {:cont, step({ip, registers}, instruction, ip_bind)}
      end
    end)
    |> elem(1)
    |> Enum.at(0)
  end
  
  @doc """
      iex> Day19.step({0, [0, 0, 0, 0, 0, 0]}, {:seti, 5, 0, 1}, 0)
      {1, [0, 5, 0, 0, 0, 0]}
      
      iex> Day19.step({1, [1, 5, 0, 0, 0, 0]}, {:seti, 6, 0, 2}, 0)
      {2, [1, 5, 6, 0, 0, 0]}
      
      iex> Day19.step({2, [2, 5, 6, 0, 0, 0]}, {:addi, 0, 1, 0}, 0)
      {4, [3, 5, 6, 0, 0, 0]}
      
      iex> Day19.step({4, [4, 5, 6, 0, 0, 0]}, {:setr, 1, 0, 0}, 0)
      {6, [5, 5, 6, 0, 0, 0]}
  """
  def step({ip, registers}, instruction, ip_bind) do
    opcode = elem(instruction, 0)
    a = elem(instruction, 1)
    b = elem(instruction, 2)
    c = elem(instruction, 3)
    
    registers = List.replace_at(registers, ip_bind, ip)
    
    registers = 
      case opcode do
        :addr ->
          vala = Enum.at(registers, a)
          valb = Enum.at(registers, b)
          List.replace_at(registers, c, vala + valb)
        :addi ->
          vala = Enum.at(registers, a)
          valb = b
          List.replace_at(registers, c, vala + valb)
        :mulr ->
          vala = Enum.at(registers, a)
          valb = Enum.at(registers, b)
          List.replace_at(registers, c, vala * valb)
        :muli ->
          vala = Enum.at(registers, a)
          valb = b
          List.replace_at(registers, c, vala * valb)
        :setr ->
          vala = Enum.at(registers, a)
          List.replace_at(registers, c, vala)
        :seti ->
          vala = a
          List.replace_at(registers, c, vala)
        :gtir ->
          vala = a
          valb = Enum.at(registers, b)
          List.replace_at(registers, c, (if vala > valb, do: 1, else: 0))
        :gtri ->
          vala = Enum.at(registers, a)
          valb = b
          List.replace_at(registers, c, (if vala > valb, do: 1, else: 0))
        :gtrr ->
          vala = Enum.at(registers, a)
          valb = Enum.at(registers, b)
          List.replace_at(registers, c, (if vala > valb, do: 1, else: 0))
        :eqir ->
          vala = a
          valb = Enum.at(registers, b)
          List.replace_at(registers, c, (if vala == valb, do: 1, else: 0))
        :eqri ->
          vala = Enum.at(registers, a)
          valb = b
          List.replace_at(registers, c, (if vala == valb, do: 1, else: 0))
        :eqrr ->
          vala = Enum.at(registers, a)
          valb = Enum.at(registers, b)
          List.replace_at(registers, c, (if vala == valb, do: 1, else: 0))
      end
    {Enum.at(registers, ip_bind) + 1, registers}
  end

  @doc """
      iex> Day19.ip_bind("priv/example.txt")
      0
  """
  defmemo ip_bind(filename) do
    [ip_bind | _instructions] = read(filename)
    ip_bind
    |> String.split(" ")
    |> List.last()
    |> String.to_integer()
  end
  
  @doc """
      iex> instructions = Day19.instructions("priv/example.txt")
      ...> length(instructions)
      7
  """
  defmemo instructions(filename) do
    [_ip | instructions] = read(filename)
    instructions
    |> Enum.map(fn instruction ->
      parse(instruction)
    end)
  end
  
  @doc """
      iex> Day19.parse("seti 5 0 1")
      {:seti, 5, 0, 1}
  """
  def parse(instruction) do
    instruction
    |> String.split(" ")
    |> Enum.with_index()
    |> Enum.map(fn {comp, index} ->
      case index do
        0 ->
          String.to_atom(comp)
        _ ->
          String.to_integer(comp)
      end
    end)
    |> List.to_tuple()
  end

  @doc """
      iex> file = Day19.read("priv/example.txt")
      ...> length(file)
      8
  """
  defmemo read(filename) do
    filename
    |> File.read!
    |> String.split("\n")
  end
end
