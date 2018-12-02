input = 'input.txt'
  |> File.read!
  |> String.trim
  |> String.split

defmodule Checksum do
  def diff(input) do
    list = input
      |> Enum.map(&String.graphemes/1)

    for row <- list,
        col <- list do
      if length(row -- col) == 1 do
        diff = row
        |> Enum.with_index
        |> Enum.reduce(0, fn {x, index}, acc ->
          if x == Enum.at(col, index), do: acc, else: acc + 1
        end)

        if diff == 1 do
          res = col -- row
          IO.inspect "#{col -- res}"
          System.halt(0)
        end
      end
    end
  end
end

Checksum.diff(input)
