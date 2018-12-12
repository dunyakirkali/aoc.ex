defmodule Day12 do
  @moduledoc """
  Documentation for Day12.
  """

  def iterate(_, string, 0), do: string
  def iterate(filename, string, generations) do
    IO.inspect(generations, label: "Gen")
    codepoints =
      string
      # |> IO.inspect
      |> String.codepoints

    chunks =
      codepoints
      |> Enum.chunk_every(5, 1, :discard)

    # IO.inspect(length(chunks), label: "chunks")
    lookedup =
      chunks
      |> Enum.map(fn list -> Enum.join(list, "") end)
      |> Enum.map(fn chunk -> lookup(filename, chunk) end)

    # IO.inspect(length(lookedup), label: "next")

    next_iteration = Enum.take(codepoints, 2) ++ lookedup ++ Enum.take(codepoints, -2)

    # IO.inspect(length(next_iteration), label: "next")
    iterate(filename, Enum.join(next_iteration, ""), generations - 1)
  end

  @doc """
      iex> Day12.lookup("priv/example.txt", "..#..")
      "#"

      iex> Day12.lookup("priv/example.txt", "##.##")
      "#"

      iex> Day12.lookup("priv/example.txt", ".##.#")
      "."

      iex> Day12.lookup("priv/example.txt", "####.")
      "#"
  """
  def lookup(filename, rule) do
    lookup = rules(filename)[rule]
    if lookup == nil do
      "."
    else
      lookup
    end
  end

  def rules(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.filter(fn {_, index} -> index > 0 end)
    |> Enum.map(fn {line, _} -> String.split(line, " => ") end)
    |> Enum.reduce(%{}, fn [from, to], acc ->
      Map.put(acc, from, to)
    end)
  end

  def initial_state(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.filter(fn {_, index} -> index == 0 end)
    |> Enum.map(fn {line, _} -> List.last(String.split(line, ": ")) end)
    |> List.first
  end
end
