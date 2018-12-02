input = 'input.txt' |> File.read!

defmodule Frequency do
  def calculate(input) do
    input
      |> String.trim
      |> String.split
      |> Enum.map(&String.to_integer/1)
      |> Enum.sum
  end
end

Frequency.calculate(input)
  |> IO.puts
