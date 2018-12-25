defmodule Day21 do
  use Memoize
  use Bitwise

  @moduledoc """
  Documentation for Day21.
  """
  
  def part_1(filename, registers \\ [0, 0, 0, 0, 0, 0]) do
    ip_bind = ip_bind(filename)
    instructions = instructions(filename)
    
    0..999_999_999_999
    |> Enum.reduce_while({Enum.at(registers, ip_bind), registers}, fn _, {ip, registers} ->
      
      if ip >= length(instructions) do
        {:halt, {ip, registers}}
      else
        instruction = Enum.at(instructions, ip)
        IO.inspect({registers, instruction, step({ip, registers}, instruction, ip_bind)}, width: :infinity)
        Process.sleep(100)
        {:cont, step({ip, registers}, instruction, ip_bind)}
      end
    end)
    |> elem(1)
    |> Enum.at(0)
  end
  
  @doc """
      iex> Day21.step({0, [0, 0, 0, 0, 0, 0]}, {:seti, 5, 0, 1}, 0)
      {1, [0, 5, 0, 0, 0, 0]}
      
      iex> Day21.step({1, [1, 5, 0, 0, 0, 0]}, {:seti, 6, 0, 2}, 0)
      {2, [1, 5, 6, 0, 0, 0]}
      
      iex> Day21.step({2, [2, 5, 6, 0, 0, 0]}, {:addi, 0, 1, 0}, 0)
      {4, [3, 5, 6, 0, 0, 0]}
      
      iex> Day21.step({4, [4, 5, 6, 0, 0, 0]}, {:setr, 1, 0, 0}, 0)
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
        :banr ->
          vala = Enum.at(registers, a)
          valb = Enum.at(registers, b)
          List.replace_at(registers, c, band(vala, valb))
        :bani ->
          vala = Enum.at(registers, a)
          valb = b
          List.replace_at(registers, c, band(vala, valb))
        :borr ->
          vala = Enum.at(registers, a)
          valb = Enum.at(registers, b)
          List.replace_at(registers, c, bor(vala, valb))
        :bori ->
          vala = Enum.at(registers, a)
          valb = b
          List.replace_at(registers, c, bor(vala, valb))
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
      iex> Day21.ip_bind("priv/input.txt")
      4
  """
  defmemo ip_bind(filename) do
    [ip_bind | _instructions] = read(filename)
    ip_bind
    |> String.split(" ")
    |> List.last()
    |> String.to_integer()
  end
  
  @doc """
      iex> instructions = Day21.instructions("priv/input.txt")
      ...> length(instructions)
      31
  """
  defmemo instructions(filename) do
    [_ip | instructions] = read(filename)
    instructions
    |> Enum.map(fn instruction ->
      parse(instruction)
    end)
  end
  
  @doc """
      iex> Day21.parse("seti 5 0 1")
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
      iex> file = Day21.read("priv/input.txt")
      ...> length(file)
      32
  """
  defmemo read(filename) do
    filename
    |> File.read!
    |> String.split("\n")
  end
end
