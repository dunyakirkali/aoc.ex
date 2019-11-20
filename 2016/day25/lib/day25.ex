defmodule Day25 do
  def part_1(filename) do
    trust = 12
    lines =
      filename
      |> File.read!()
      |> String.split("\n", trim: true)

    0..999_999_999
    |> Enum.reduce_while(0, fn index, acc ->
      index |> IO.inspect(label: "I")
      registers = %{"a" => index}
      collected = []
      case1 = for n <- 0..(trust - 1) do
        if rem(n, 2) == 0 do
          0
        else
          1
        end
      end
      case2 = for n <- 0..(trust - 1) do
        if rem(n, 2) != 0 do
          0
        else
          1
        end
      end

      signals =
        0..999_999_999
        |> Enum.reduce_while({collected, registers, lines, 0}, fn _, {collected, registers, lines, index} ->
          if index >= length(lines) do
            {:halt, collected}
          else
            {collected, registers, lines, index} = parse(collected, registers, lines, index)

            if length(collected) == trust do
              {:halt, collected}
            else
              {:cont, {collected, registers, lines, index}}
            end
          end
        end)

      IO.inspect(signals, label: "signals")

      if signals == case1 do
        {:halt, index}
      else
        if signals == case2 do
          {:halt, index}
        else
          {:cont, index}
        end
      end
    end)
  end

  defp parse(collected, registers, lines, index) do
    # lines |> IO.inspect(label: "lines")
    # registers |> IO.inspect(label: "registers")

    line = Enum.at(lines, index)
    # |> IO.inspect(label: "L")
    cond do
      String.contains?(line, "out") ->

        [_, register] = String.split(line, " ")

        val = value(registers, register)# |> IO.inspect(label: "transmit")

        {[val | collected], registers, lines, index + 1}

      String.contains?(line, "cpy") ->

        [_, from, register] = String.split(line, " ")

        {collected, copy(registers, register, value(registers, from)), lines, index + 1}

      String.contains?(line, "inc") ->

        [_, register] = String.split(line, " ")

        {collected, increment(registers, register), lines, index + 1}

      String.contains?(line, "dec") ->

        [_, register] = String.split(line, " ")

        {collected, decrement(registers, register), lines, index + 1}

      String.contains?(line, "jnz") ->

        [_, from, jump] = String.split(line, " ")

        jump(collected, registers, value(registers, from), value(registers, jump), lines, index)

      String.contains?(line, "tgl") ->

        [_, jump] = String.split(line, " ")

        toggle(collected, registers, jump, index, lines)
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

  defp jump(collected, registers, val, jump, lines, index) do
    if val != 0 do
      {collected, registers, lines, index + jump}
    else
      {collected, registers, lines, index + 1}
    end
  end

  defp value(registers, char) do
    case Integer.parse(char) do
      :error -> Map.get(registers, char)
      {val, _} -> val
    end
  end

  defp toggle(collected, registers, jump, index, lines) do
    jump_val = Map.get(registers, jump)
    # |> IO.inspect(label: "tgl val")

    if index + jump_val >= Enum.count(lines) do
      {registers, lines, index + 1}
    else
      line = Enum.at(lines, index + jump_val)
      # |> IO.inspect(label: "line")

      cond do
        String.contains?(line, "cpy") ->

          [_, from, jump] = String.split(line, " ")

          {collected, registers, List.replace_at(lines, index + jump_val, "jnz #{from} #{jump}"), index + 1}

        String.contains?(line, "inc") ->

          [_, register] = String.split(line, " ")

          {collected, registers, List.replace_at(lines, index + jump_val, "dec #{register}"), index + 1}

        String.contains?(line, "dec") ->

          [_, register] = String.split(line, " ")

          {collected, registers, List.replace_at(lines, index + jump_val, "inc #{register}"), index + 1}

        String.contains?(line, "jnz") ->

          [_, from, jump] = String.split(line, " ")

          {collected, registers, List.replace_at(lines, index + jump_val, "cpy #{from} #{jump}"), index + 1}

        String.contains?(line, "tgl") ->

          [_, register] = String.split(line, " ")

          {collected, registers, List.replace_at(lines, index + jump_val, "inc #{register}"), index + 1}
      end
    end
  end
end
