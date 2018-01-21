ingredients = [
  %{capacity: 5, durability: -1, flavor: 0, texture: 0, calories: 5},
  %{capacity: -1, durability: 3, flavor: 0, texture: 0, calories: 1},
  %{capacity: 0, durability: -1, flavor: 4, texture: 0, calories: 6},
  %{capacity: -1, durability: 0, flavor: 0, texture: 2, calories: 8},
]

defmodule Permutations do
  def shuffle(list), do: shuffle(list, length(list))

  def shuffle([], _), do: [[]]
  def shuffle(_,  0), do: [[]]
  def shuffle(list, i) do
    for x <- list, y <- shuffle(list, i-1), do: [x|y]
  end
end

range = 1..100
all = for i <- range, j <- range, k <- range, l <- range, do: [i, j, k, l]
all_percentages = all
  |> IO.inspect
  |> Enum.filter(fn(list) ->
    list |> Enum.sum == 100
  end)
  |> IO.inspect

keys = ingredients
  |> List.first
  |> Map.keys

all_percentages
  |> Enum.map(fn(percentages) ->
    keys
      |> Enum.map(fn(key) ->
        ingredients
          |> Enum.with_index
          |> Enum.map(fn({ingredient, index}) ->
            percentage = Enum.at(percentages, index)
            percentage * ingredient[key]
          end)
          |> Enum.sum
      end)
      |> List.delete_at(0)
      |> Enum.map(fn(tot) ->
        if tot <= 0 do
          0
        else
          tot
        end
      end)
      |> Enum.reduce(1, fn(x, acc) ->
        acc * x
      end)
  end)
  |> Enum.max
  |> IO.inspect
