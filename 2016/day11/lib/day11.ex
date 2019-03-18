
defmodule Day11 do
  @doc """
      iex> Day11.part_1("priv/example.txt")
      11
  """
  def part_1(file) do
    floors = %{
      :F1 => [],
      :F2 => [],
      :F3 => [],
      :F4 => []
    }
    
    floors = parse(floors, file)
  end
  
  defp parse(floors, file) do
    file
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(floors, fn {line, floor}, acc ->
      IO.inspect(floor)

      match =
        Regex.scan(~r/(\S+ microchip)/, line)
        |> Enum.map(&List.last/1)
        |> IO.inspect
      
      floor_atom = String.to_atom("F#{floor + 1}")
      
      acc =
        if length(match) > 0 do
          Map.update!(acc, floor_atom, &(match ++ &1))
          |> IO.inspect
        else
          acc
        end
      
      match =
        Regex.scan(~r/(\S+ generator)/, line)
        |> Enum.map(&List.last/1)
        |> IO.inspect
      
      acc =
        if length(match) > 0 do
          Map.update!(acc, floor_atom, &(match ++ &1))
          |> IO.inspect
        else
          acc
        end
    end)
  end
end
