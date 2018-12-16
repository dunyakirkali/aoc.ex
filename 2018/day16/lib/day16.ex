defmodule Day16 do
  use Bitwise
  
  @opcodes [:addr, :addi, :mulr, :muli, :banr, :bani, :borr, :bori, :setr, :seti, :gtir, :gtri, :gtrr, :eqir, :eqri, :eqrr]
  
  @moduledoc """
  Documentation for Day16.
  """
  
  def part_2() do
    "priv/input.txt"
    |> changes()
    |> find_opcodes()
    |> run()
  end
  
  def part_1() do
    "priv/input.txt"
    |> changes()
    |> bahaviours()
  end
  
  def run(opcodes) do
    "priv/input.txt"
    |> file_part_2()
    |> Enum.reduce([0, 0, 0, 0], fn action, acc ->
      action_list = action |> String.split(" ") |> Enum.map(&String.to_integer/1)
      code = List.first(action_list)
      real_action = List.replace_at(action_list, 0, opcodes[code]) |> List.to_tuple
      operate(acc, real_action)
    end)
    |> Enum.at(0)
  end
  
  def find_opcodes(changes) do
    changes
    |> Enum.reduce(%{}, fn change, acc ->

      registers_before =
        change
        |> Enum.at(0)
        |> String.split(": ")
        |> Enum.at(1)
        |> String.slice(1..-1)
        |> String.slice(0..-2)
        |> String.split(", ")
        |> Enum.map(&String.to_integer/1)
      action =
        change
        |> Enum.at(1)
        |> String.split(" ")
        |> Enum.map(&String.to_integer/1)
      registers_after =
         change
         |> Enum.at(2)
         |> String.split(":  ")
         |> Enum.at(1)
         |> String.slice(1..-1)
         |> String.slice(0..-2)
         |> String.split(", ")
         |> Enum.map(&String.to_integer/1)
      
      findings =
        @opcodes
        |> Enum.filter(fn opcode ->
          !Enum.member?(Map.values(acc), opcode)
        end)
        |> Enum.map(fn opcode ->
          code = Enum.at(action, 0)
          
          if Enum.member?(Map.keys(acc), code) do
            {code, opcode, false}
          else
            tuple_action = List.replace_at(action, 0, opcode) |> List.to_tuple
            {code, opcode, registers_after == operate(registers_before, tuple_action)}
          end
        end)
        |> Enum.filter(fn {_, _, res} -> res end)
        
      if length(findings) == 1 do
        finding = List.first(findings)
        Map.put(acc, elem(finding, 0), elem(finding, 1))
      else
        acc
      end
    end)
  end
  
  def bahaviours(changes) do
    changes
    |> Enum.map(fn change ->
      
      # len = String.length(a)
      # String.slice(a, -len + 1, len - 1)

      registers_before =
        change
        |> Enum.at(0)
        |> String.split(": ")
        |> Enum.at(1)
        |> String.slice(1..-1)
        |> String.slice(0..-2)
        |> String.split(", ")
        |> Enum.map(&String.to_integer/1)
      action =
        change
        |> Enum.at(1)
        |> String.split(" ")
        |> Enum.map(&String.to_integer/1)
      registers_after =
         change
         |> Enum.at(2)
         |> String.split(":  ")
         |> Enum.at(1)
         |> String.slice(1..-1)
         |> String.slice(0..-2)
         |> String.split(", ")
         |> Enum.map(&String.to_integer/1)
      
      @opcodes
      |> Enum.map(fn opcode ->
        tuple_action = List.replace_at(action, 0, opcode) |> List.to_tuple
        registers_after == operate(registers_before, tuple_action)
      end)
      |> Enum.filter(fn res -> res end)
      |> Enum.count
    end)
    |> Enum.filter(fn behaviours -> behaviours >= 3 end)
    |> Enum.count
  end
  
  @doc """
      iex> Day16.operate([1, 2, 3, 4], {:addr, 2, 1, 2})
      [1, 2, 5, 4]
      
      iex> Day16.operate([1, 2, 3, 4], {:addi, 2, 1, 2})
      [1, 2, 4, 4]
      
      iex> Day16.operate([1, 2, 3, 4], {:mulr, 2, 1, 2})
      [1, 2, 6, 4]
      
      iex> Day16.operate([1, 2, 3, 4], {:muli, 2, 1, 2})
      [1, 2, 3, 4]
      
      iex> Day16.operate([1, 2, 3, 4], {:banr, 2, 1, 2})
      [1, 2, 2, 4]
      
      iex> Day16.operate([1, 2, 3, 4], {:bani, 2, 1, 2})
      [1, 2, 1, 4]
      
      iex> Day16.operate([1, 2, 3, 4], {:borr, 2, 1, 2})
      [1, 2, 3, 4]
      
      iex> Day16.operate([1, 2, 3, 4], {:bori, 2, 1, 2})
      [1, 2, 3, 4]
      
      iex> Day16.operate([1, 2, 3, 4], {:setr, 2, 1, 3})
      [1, 2, 3, 3]
      
      iex> Day16.operate([1, 2, 3, 4], {:seti, 2, 1, 2})
      [1, 2, 2, 4]
      
      iex> Day16.operate([1, 2, 3, 4], {:gtir, 2, 1, 2})
      [1, 2, 0, 4]
      
      iex> Day16.operate([1, 2, 3, 4], {:gtri, 2, 1, 2})
      [1, 2, 1, 4]
      
      iex> Day16.operate([1, 2, 3, 4], {:gtrr, 2, 1, 2})
      [1, 2, 1, 4]
      
      iex> Day16.operate([1, 2, 3, 4], {:eqir, 2, 1, 2})
      [1, 2, 1, 4]
      
      iex> Day16.operate([1, 2, 3, 4], {:eqri, 2, 1, 2})
      [1, 2, 0, 4]
      
      iex> Day16.operate([1, 2, 3, 4], {:eqrr, 2, 1, 2})
      [1, 2, 0, 4]
  """
  def operate(registers, action) do
    opcode = elem(action, 0)
    a = elem(action, 1)
    b = elem(action, 2)
    c = elem(action, 3)
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
  end
  
  @doc """
      iex> file = Day16.changes("priv/input.txt")
      ...> length(file)
      776
  """
  def changes(filename) do
    filename
    |> file_part_1()
    |> Enum.chunk_every(4)
    |> Enum.map(fn chunk ->
      Enum.filter(chunk, fn piece -> piece != "" end)
    end)
  end
    
  @doc """
      iex> file = Day16.file_part_1("priv/input.txt")
      ...> length(file)
      3103
  """
  def file_part_1(filename) do
    filename
    |> file()
    |> Enum.take(3103)
  end
  
  @doc """
      iex> file = Day16.file_part_2("priv/input.txt")
      ...> length(file)
      898
  """
  def file_part_2(filename) do
    filename
    |> file()
    |> Enum.take(-898)
  end
  
  @doc """
      iex> file = Day16.file("priv/input.txt")
      ...> length(file)
      4004
  """
  def file(filename) do
    filename
    |> File.read!
    |> String.split("\n")
  end
end
