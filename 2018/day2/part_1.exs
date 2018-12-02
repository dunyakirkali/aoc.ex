input = 'input.txt'
  |> File.read!
  |> String.trim
  |> String.split

defmodule Checksum do
  @lengths [2, 3]

  def calculate(input) do
    counts = input
      |> letter_frequencies_of_length
      |> Enum.reduce([], fn x, acc ->
        list = x
          |> Map.new
          |> Map.values
          |> Enum.uniq
        acc ++ [list]
      end)
      |> List.flatten

    Enum.count(counts, &(&1 == 2)) * Enum.count(counts, &(&1 == 3))
  end

  defp letter_frequencies_of_length(input) do
    input
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(fn(list) ->
        Enum.reduce(list, %{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
          |> Enum.filter(fn {_, val} ->
            Enum.member?(@lengths, val)
          end)
      end)
  end
end

Checksum.calculate(input)
  |> IO.puts
