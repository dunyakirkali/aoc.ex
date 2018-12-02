input = 'input.txt'
  |> File.read!
  |> String.trim
  |> String.split
  |> Enum.map(&String.to_integer/1)

defmodule Frequency do
  def calculate(input) do
    input
      |> Enum.sum
  end
end

Frequency.calculate(input)
  |> IO.puts
