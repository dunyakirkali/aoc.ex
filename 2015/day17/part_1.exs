defmodule Foo do
  def combination(0, _), do: [[]]
  def combination(_, []), do: []
  def combination(n, [x|xs]) do
    (for y <- combination(n - 1, xs), do: [x|y]) ++ combination(n, xs)
  end
end

input = [11, 30, 47, 31, 32, 36, 3, 1, 5, 3, 32, 36, 15, 11, 46, 26, 28, 1, 19, 3]
to_fit = 150

Enum.to_list(1..(length(input)))
|> Enum.reduce([], fn(of_size, acc) ->
  acc ++ Foo.combination(of_size, input)
end)
|> Enum.filter(fn(x) ->
  Enum.sum(x) == to_fit
end)
|> Enum.count
|> IO.inspect
