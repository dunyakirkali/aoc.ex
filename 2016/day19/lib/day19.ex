defmodule Day19 do
  @doc """
      iex> Day19.part_1(5)
      3
  """
  def part_1(elf_count) do
    elves =
      0..(elf_count - 1)
      |> Enum.map(fn elf ->
        {elf, 1}
      end)
      |> Enum.into(%{})
      |> IO.inspect()
  
    turn(elves, 0)
  end
  
  def turn(elves, index) do
    elves_with_presents =
      elves
      |> Enum.filter(fn {elf, present} ->
        present == 1
      end)
  
    if Enum.count(elves_with_presents) == 1 do
      index
    else
      if Map.get(elves, index) == 0 do
        IO.puts("Elf #{index} has no presents and is skipped.")
        turn(elves, index + 1)
      else
        next_key =
          elves
          |> Enum.to_list
          |> Enum.sort
          |> List.duplicate(2)
          |> List.flatten
          # |> IO.inspect(label: "a")
          |> Enum.drop(index + 1)
          # |> IO.inspect(label: "b")
          |> Enum.find(fn {k, v} -> v == 1 end)
          # |> IO.inspect(label: "c")
          |> elem(0)
        IO.puts("Elf #{index} takes Elf #{next_key}'s present.")
        turn(Map.put(elves, next_key, 0), rem(index + 1, map_size(elves)))
      end
    end
  end
end
