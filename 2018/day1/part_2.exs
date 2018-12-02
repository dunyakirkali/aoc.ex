input = 'input.txt'
  |> File.read!
  |> String.trim
  |> String.split
  |> Enum.map(&String.to_integer/1)

defmodule Frequency do
  def visited(input) do
    input      
      |> Stream.cycle
      |> Enum.reduce_while({0, [0]}, fn(x, acc) ->
        {sum, visited} = acc
        visit = sum + x
        if Enum.member?(visited, visit) do
          {:halt, {visit, visited}}
        else
          {:cont, {visit, visited ++ [visit]}}
        end
      end)
      |> elem(0)
  end
end

Frequency.visited(input)
  |> IO.puts
