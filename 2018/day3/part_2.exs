input = 'input.txt'
  |> File.read!
  |> String.trim
  |> String.split

defmodule TODO do
  def calculate(input) do
    input
  end
end

TODO.calculate(input)
  |> IO.puts
