defmodule Day23 do
  def part_2(filename, val) do
    (96 * 91) + fac(val)
  end

  @doc """
      iex> Day23.fac(1)
      1

      iex> Day23.fac(6)
      720
  """
  def fac(n) when n == 1, do: 1
  def fac(n), do: n * fac(n - 1)

  @doc """
      iex> Day23.part_1("priv/sample.txt", 7)
      3
  """
  def part_1(filename, val) do
    lines =
      filename
      |> File.read!()
      |> String.split("\n", trim: true)

    registers = %{"a" => val}

    0..999_999_999
    |> Enum.reduce_while({registers, lines, 0}, fn _, {registers, lines, index} ->
      if index >= length(lines) do
        {:halt, registers}
      else
        {:cont, parse(registers, lines, index)}
      end
    end)
    |> Map.get("a")
  end

  defp parse(registers, lines, index) do
    # lines |> IO.inspect(label: "lines")
    # registers |> IO.inspect(label: "registers")

    line = Enum.at(lines, index)
    # |> IO.inspect(label: "L")
    cond do
      String.contains?(line, "cpy") ->

        [_, from, register] = String.split(line, " ")

        {copy(registers, register, value(registers, from)), lines, index + 1}

      String.contains?(line, "inc") ->

        [_, register] = String.split(line, " ")

        {increment(registers, register), lines, index + 1}

      String.contains?(line, "dec") ->

        [_, register] = String.split(line, " ")

        {decrement(registers, register), lines, index + 1}

      String.contains?(line, "jnz") ->

        [_, from, jump] = String.split(line, " ")

        jump(registers, value(registers, from), value(registers, jump), lines, index)

      String.contains?(line, "tgl") ->

        [_, jump] = String.split(line, " ")

        toggle(registers, jump, index, lines)
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

  defp jump(registers, val, jump, lines, index) do
    if val != 0 do
      {registers, lines, index + jump}
    else
      {registers, lines, index + 1}
    end
  end

  defp value(registers, char) do
    case Integer.parse(char) do
      :error -> Map.get(registers, char)
      {val, _} -> val
    end
  end

  defp toggle(registers, jump, index, lines) do
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

          {registers, List.replace_at(lines, index + jump_val, "jnz #{from} #{jump}"), index + 1}

        String.contains?(line, "inc") ->

          [_, register] = String.split(line, " ")

          {registers, List.replace_at(lines, index + jump_val, "dec #{register}"), index + 1}

        String.contains?(line, "dec") ->

          [_, register] = String.split(line, " ")

          {registers, List.replace_at(lines, index + jump_val, "inc #{register}"), index + 1}

        String.contains?(line, "jnz") ->

          [_, from, jump] = String.split(line, " ")

          {registers, List.replace_at(lines, index + jump_val, "cpy #{from} #{jump}"), index + 1}

        String.contains?(line, "tgl") ->

          [_, register] = String.split(line, " ")

          {registers, List.replace_at(lines, index + jump_val, "inc #{register}"), index + 1}
      end
    end
  end
end
