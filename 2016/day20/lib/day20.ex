defmodule Day20 do
  @doc """
      iex> Day20.part_1("priv/example.txt")
      3
  """
  def part_1(file) do
    [_..first, last.._] = 
      file
      |> File.read!
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [from, to] =
          line
          |> String.split("-")
          |> Enum.sort
          |> Enum.map(&String.to_integer/1)
        
        from..to
      end)
      |> IO.inspect(label: "not - ordered")
      |> Enum.sort
      |> IO.inspect(label: "list ordered")
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.drop_while(fn [from_range_s..from_range_e, to_range_s..to_range_e] ->
        from_range_e + 1 >= to_range_s
      end)
      |> List.first
      |> IO.inspect(label: "-")
    
    first + 1
  end
end
