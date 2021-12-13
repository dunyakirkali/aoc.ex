defmodule Aoc.Day9 do
  @doc """
      # iex> Aoc.Day9.part1("priv/day9/example_1.txt")
      # [109,1,204,-1,1001,100,1,100,1008,100,16,101,1006,101,0,99]
      #
      # iex> Aoc.Day9.part1("priv/day9/example_2.txt") |> Enum.at(0) |> Integer.digits |> Enum.count
      # 16
      #
      # iex> Aoc.Day9.part1("priv/day9/example_3.txt") |> Enum.at(0)
      # 1125899906842624
  """
  def part1(filename) do
    filename
    |> AGC.new()
    |> AGC.run()
    |> Map.get(:output)
  end
end
