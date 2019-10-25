defmodule Day18 do
  @doc """
      iex> Day18.part_1("..^^.", 3)
      6

      iex> Day18.part_1(".^^.^.^^^^", 10)
      38
  """
  def part_1(input, rows) do
    1..rows
    |> Enum.reduce({input, ""}, fn _, {input, acc} ->
      next_line = produce_next(input)
      {next_line, acc <> input}
    end)
    |> elem(1)
    |> String.codepoints
    |> Enum.count(&(&1 == "."))
  end

  @doc """
      iex> Day18.produce_next("..^^.")
      ".^^^^"

      iex> Day18.produce_next(".^^^^")
      "^^..^"

      iex> Day18.produce_next(".^^.^.^^^^")
      "^^^...^..^"
  """
  def produce_next(line) do
    wall = ["."]

    wall
    |> Kernel.++(String.codepoints(line))
    |> Kernel.++(wall)
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.reduce([], fn list, acc ->
      next = if trap?(list), do: "^", else: "."
      [acc | [next] ]
    end)
    |> Enum.join
  end

  defp trap?(list) do
    case list do
      ["^", "^", "."] -> true
      [".", "^", "^"] -> true
      ["^", ".", "."] -> true
      [".", ".", "^"] -> true
      _ -> false
    end
  end
end
