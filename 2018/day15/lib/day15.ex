defmodule Day15 do
  use Vivid
  
  @moduledoc """
  Documentation for Day15.
  """

  def parse_map(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn row ->
      String.codepoints(row)
    end)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {col, y}, acc ->
      col
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {char, x}, acc ->
        Map.put(acc, {x, y}, char)
      end)
    end)
  end
end
