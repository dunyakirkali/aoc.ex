input = './day12/input.txt' |> File.read!

regex = ~r/-?[0-9]\d*/

Regex.scan(regex, input)
|> List.flatten
|> Enum.reduce(0, fn(x, acc) -> 
  case Integer.parse(x) do
    {intVal, _} -> acc + intVal
    :error -> acc
  end
end)
|> IO.inspect
