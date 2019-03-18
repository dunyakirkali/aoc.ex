defmodule Day23 do
  def part_2() do
    start = (84 * 100 + 100000)
    start..(start + 17000)
    |> Enum.take_every(17)
    |> Enum.filter(fn n ->
      !is_prime?(n)
    end)
    |> Enum.count
  end
  
  defp is_prime?(n) when n in [2, 3], do: true
  defp is_prime?(x) do
    start_lim = div(x, 2)
    Enum.reduce(2..start_lim, {true, start_lim}, fn(fac, {is_prime, upper_limit}) ->
      cond do
        !is_prime -> {false, fac}
        fac > upper_limit -> {is_prime, upper_limit}
        true ->
          is_prime = rem(x, fac) != 0
          upper_limit = if is_prime, do: div(x, fac + 1), else: fac
          {is_prime , upper_limit}
      end
    end) |> elem(0)
  end
  
  def part_1(commands) do
    registers = %{
      "a" => 0,
      "b" => 0,
      "c" => 0,
      "d" => 0,
      "e" => 0,
      "f" => 0,
      "g" => 0,
      "h" => 0
    }
    
    parse_command(commands, commands, registers, 0)
    |> elem(1)
  end
  
  def parse_command(all, [], registers, count), do: {registers, count}
  def parse_command(all, [head | tail], registers, count) do
    # IO.inspect(registers, label: "registers")
    # IO.inspect(head, label: "head")
    [cmd, x, y] =
      head
      |> String.split(" ")
    
    [registers, count, tail] =
      case cmd do
        "set" ->
          [parse_set(registers, x, y), count, tail]
        "jnz" ->
          tail = parse_jump(registers, x, y, tail, all)
          [registers, count, tail]
        "mul" ->
          [parse_mul(registers, x, y), count + 1, tail]
        "sub" ->
          [parse_sub(registers, x, y), count, tail]
      end
    
    parse_command(all, tail, registers, count)
  end
  
  defp parse_sub(registers, x, y) do
    value = int_or_string(registers, y)
    Map.update!(registers, x, &(&1 - value))
  end
  
  defp parse_mul(registers, x, y) do
    value = int_or_string(registers, y)
    Map.update!(registers, x, &(&1 * value))
  end
  
  defp parse_jump(registers, x, y, tail, all) do
    value = int_or_string(registers, x)
    if value != 0 do
      jump = int_or_string(registers, y)
      # IO.inspect(jump, label: "JUMP")
      if jump > 0 do
        Enum.take(tail, -1 * (length(tail) - jump + 1))
        # |> IO.inspect
      else
        case jump do
          -8 ->
            Enum.slice(all, 11, 9) ++ tail
            # |> IO.inspect(label: "chheck")
          -13 ->
            Enum.slice(all, 10, 14) ++ tail
          -23 ->
            Enum.slice(all, 8, 24) ++ tail 
        end
      end
    else
      tail
    end
  end
  
  defp parse_set(registers, x, y) do
    value = int_or_string(registers, y)
    Map.put(registers, x, value)
  end
  
  defp int_or_string(registers, item) do
    case Integer.parse(item) do
      :error ->
        Map.get(registers, item)
      {value, _} ->
        value
    end
  end
end
