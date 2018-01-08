defmodule M do
  def permutations([]), do: [[]]
  def permutations(list), do: for elem <- list, rest <- permutations(list--[elem]), do: [elem|rest]
end

input = './day9/input.txt' |> File.read! |> String.split("\n", trim: true) |> Enum.map(&(String.split(&1," ")))
stars = input
  |> Enum.reduce([], fn([from, "to", to, "=", _], acc) ->
    acc ++ [from, to]
  end)
  |> Enum.uniq

distances = input
  |> Enum.map(fn([from, "to", to, "=", distance]) ->
    [from, to, distance]
  end)

stars
  |> M.permutations
  |> Enum.map(fn(perm) ->
    perm
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn([from, to]) ->
        route = Enum.find(distances, fn(dist) ->
          Enum.member?(dist, from) && Enum.member?(dist, to)
        end)
        String.to_integer(List.last(route))
      end)
      |> Enum.sum
  end)
  |> Enum.max
  |> IO.inspect
