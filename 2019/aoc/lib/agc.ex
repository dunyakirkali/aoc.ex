defmodule AGC do
  defstruct [:instructions, :ip]

  def new(filename) do
    instructions = input(filename)
    %AGC{instructions: instructions}
  end

  def run(machine) do
    machine.instructions
    |> Enum.chunk_while([], &chunk_line/2, fn
      [] -> {:cont, []}
      acc -> {:cont, Enum.reverse(acc), []}
    end)
    |> Enum.reduce_while(machine.instructions, fn instruction, acc ->
      case instruction do
        [1, ini1, ini2, outi] -> {:cont, add(acc, ini1, ini2, outi)}
        [2, ini1, ini2, outi] -> {:cont, mul(acc, ini1, ini2, outi)}
        [99] -> {:halt, Enum.at(acc, 0)}
      end
    end)
  end

  defp chunk_line(element, acc) when length(acc) == 0 and element == 99, do: {:cont, [element], []}
  defp chunk_line(element, acc) when length(acc) == 0, do: {:cont, [element | acc]}
  defp chunk_line(element, acc) when length(acc) == 3, do: {:cont, Enum.reverse([element | acc]), []}
  defp chunk_line(element, acc), do: {:cont, [element | acc]}

  def set(machine, noun, verb) do
    new_instructions =
      machine.instructions
      |> List.replace_at(1, noun)
      |> List.replace_at(2, verb)

    %AGC{machine | instructions: new_instructions}
  end

  defp input(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(fn x ->
      String.to_integer(x)
    end)
  end

  defp mul(instructions, ini1, ini2, outi) do
    in1 = Enum.at(instructions, ini1)
    in2 = Enum.at(instructions, ini2)
    List.replace_at(instructions, outi, in1 * in2)
  end

  defp add(instructions, ini1, ini2, outi) do
    in1 = Enum.at(instructions, ini1)
    in2 = Enum.at(instructions, ini2)
    List.replace_at(instructions, outi, in1 + in2)
  end
end
