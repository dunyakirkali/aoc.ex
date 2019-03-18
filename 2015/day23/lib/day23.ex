defmodule Day23 do
  def part_2(commands) do
    part_1(commands, %{"a" => 1, "b" => 0})
  end
  
  @doc """
      iex> Day23.part_1([
      ...>   "inc a",
      ...>   "jio a, +2",
      ...>   "tpl a",
      ...>   "inc a"
      ...> ])
      0
  """
  def part_1(commands, registers \\ %{"a" => 0, "b" => 0}) do
    registers = parse(commands, commands, registers)
    registers["b"]
  end
  
  defp parse([], _, registers) do
    registers
  end

  defp parse([head | tail], all, registers) do
    [registers, tail] =
      cond do
        String.contains?(head, "hlf") ->
          [_, register] = String.split(head, " ")
          [Map.update!(registers, register, &(trunc(&1 / 2))), tail]
          
        String.contains?(head, "tpl") ->
          [_, register] = String.split(head, " ")
          [Map.update!(registers, register, &(&1 * 3)), tail]
          
        String.contains?(head, "inc") ->
          [_, register] = String.split(head, " ")
          [Map.update!(registers, register, &(&1 + 1)), tail]
          
        String.contains?(head, "jmp") ->
          [_, amount] = String.split(head, " ")
          {int_val, _} = Integer.parse(amount)
          
          if int_val > 0 do
            [registers, Enum.take(tail, -1 * (length(tail) - int_val + 1))]
          else
            [registers, Enum.take(all, -8)]
          end

        String.contains?(head, "jie") ->
          [command, amount] = String.split(head, ",")
          [_, register] = String.split(command, " ")
          {int_val, _} =
            amount
            |> String.trim
            |> Integer.parse
          
          if rem(registers[register], 2) == 0 do
            [registers, Enum.take(tail, -1 * (length(tail) - int_val + 1))]
          else
            [registers, tail]
          end
          
        String.contains?(head, "jio") ->
          [command, amount] = String.split(head, ",")
          [_, register] = String.split(command, " ")
          {int_val, _} =
            amount
            |> String.trim
            |> Integer.parse
          
          if registers[register] == 1 do
            [registers, Enum.take(tail, -1 * (length(tail) - int_val + 1))]
          else
            [registers, tail]
          end

      end
    
    parse(tail, all, registers)
  end
end
