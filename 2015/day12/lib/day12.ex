defmodule Day12 do
  @doc """
    Uh oh - the Accounting-Elves have realized that they double-counted
    everything red.

    Ignore any object (and all of its children) which has any property with the
    value "red". Do this only for objects ({...}), not arrays ([...]).

      iex> Day12.part_2(~s([1,2,3]))
      6
      
      iex> Day12.part_2(~s([1,{"c":"red","b":2},3]))
      4
      
      iex> Day12.part_2(~s({"d":"red","e":[1,2,3,4],"f":5}))
      0
      
      iex> Day12.part_2(~s([1,"red",5]))
      6
  """
  def part_2(json_string) do
    json_string
    |> Poison.decode!
    |> Day12.sum()
  end
  
  def sum(map) when is_map(map) do
    values = Map.values(map)

    if Enum.member?(values, "red") do
      0
    else
      values
      |> Enum.map(fn x ->
        cond do
          is_integer(x) -> x
          is_map(x) -> sum(x)
          is_list(x) -> sum(x)
          true -> 0
        end
      end)
      |> Enum.sum()
    end
  end
  
  def sum(list) when is_list(list) do
    list
    |> IO.inspect(label: "List")
    |> Enum.map(fn x ->
      cond do
        is_integer(x) -> x
        is_map(x) -> sum(x)
        is_list(x) -> sum(x)
        true -> 0
      end
    end)
    |> Enum.sum()
  end
end
