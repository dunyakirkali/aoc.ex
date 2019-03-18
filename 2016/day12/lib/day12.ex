defmodule Day12 do
  @doc """
      iex> Day12.part_2("priv/example.txt")
      42
  """
  def part_2(input) do
    registers = %{"a" => 0, "b" => 0, "c" => 1, "d" => 0}
    
    lines =
      input
      |> File.read!()
      |> String.split("\n", trim: true)
    
    0..999_999_999
    |> Enum.reduce_while({lines, 0, registers}, fn _, {lines, index, registers} ->
      if index >= length(lines) do
        {:halt, registers}
      else
        line = Enum.at(lines, index)
        {registers, index} = parse(registers, line, index)
        {:cont, {lines, index, registers}}
      end
    end)
    |> Map.get("a")
  end
  
  @doc """
      iex> Day12.part_1("priv/example.txt")
      42
  """
  def part_1(input) do
    registers = %{"a" => 0, "b" => 0, "c" => 0, "d" => 0}
    
    lines =
      input
      |> File.read!()
      |> String.split("\n", trim: true)
    
    0..999_999_999
    |> Enum.reduce_while({lines, 0, registers}, fn _, {lines, index, registers} ->
      if index >= length(lines) do
        {:halt, registers}
      else
        line = Enum.at(lines, index)
        {registers, index} = parse(registers, line, index)
        {:cont, {lines, index, registers}}
      end
    end)
    |> Map.get("a")
  end
  
  defp parse(registers, line, index) do
    cond do
      String.contains?(line, "cpy") ->
        
        [_, from, register] = String.split(line, " ")
        
        {copy(registers, register, value(registers, from)), index + 1}
        
      String.contains?(line, "inc") ->
        
        [_, register] = String.split(line, " ")
        
        {increment(registers, register), index + 1}
        
      String.contains?(line, "dec") ->
        
        [_, register] = String.split(line, " ")
        
        {decrement(registers, register), index + 1}
        
      String.contains?(line, "jnz") ->
        
        [_, from, jump] = String.split(line, " ")
      
        jump(registers, value(registers, from), String.to_integer(jump), index)
    end
  end
  
  defp increment(registers, register) do
    Map.update!(registers, register, &(&1 + 1))
  end
  
  defp decrement(registers, register) do
    Map.update!(registers, register, &(&1 - 1))
  end
  
  defp copy(registers, register, val) do
    Map.put(registers, register, val)
  end
  
  defp jump(registers, val, jump, index) do
    if val != 0 do
      {registers, index + jump}
    else
      {registers, index + 1}
    end
  end
  
  defp value(registers, char) do
    case Integer.parse(char) do
      :error -> Map.get(registers, char)
      {val, _} -> val
    end
  end
end
