defmodule Day19 do
  def part_2(desired) do
    atoms =
      Regex.scan(~r/([A-Z][a-z]*)/, desired)
      |> Enum.map(&List.first/1)
    
    ar_count =
      atoms
      |> Enum.filter(fn x ->
        x == "Ar"
      end)
      |> Enum.count
      
    rn_count =
      atoms
      |> Enum.filter(fn x ->
        x == "Rn"
      end)
      |> Enum.count
    
    y_count =
      atoms
      |> Enum.filter(fn x ->
        x == "Y"
      end)
      |> Enum.count
    
    Enum.count(atoms) - ar_count - rn_count - (2 * y_count) - 1
  end
end
