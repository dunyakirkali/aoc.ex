input = 'input.txt'
  |> File.read!
  |> String.trim
  |> String.split
  |> Enum.map(&String.to_integer/1)

defmodule Frequency do
  def visited(input) do
    input
      |> Stream.cycle
      |> Enum.reduce_while({0, MapSet.new([0])}, fn(x, {sum, visited}) ->
        visit = sum + x
        if Enum.member?(visited, visit), do: {:halt, visit}, else: {:cont, {visit, MapSet.put(visited, visit)}}
      end)
  end
end

Frequency.visited(input)
  |> IO.puts
