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
        res = row -- col
        IO.inspect "#{row} #{col}"
        IO.inspect "#{row -- res}"
        # System.halt(0)
        # FIXME: (dunyakirkali) Returns multiple candidates since we don't look at the order of characters
      end
    end
  end
end

Checksum.diff(input)
