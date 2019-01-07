defmodule Day6 do
  @moduledoc """
  Documentation for Day6.
  """

  @doc """
      iex> Day6.part_2([
      ...>   "eedadn",
      ...>   "drvtee",
      ...>   "eandsr",
      ...>   "raavrd",
      ...>   "atevrs",
      ...>   "tsrnev",
      ...>   "sdttsa",
      ...>   "rasrtv",
      ...>   "nssdts",
      ...>   "ntnada",
      ...>   "svetve",
      ...>   "tesnvt",
      ...>   "vntsnd",
      ...>   "vrdear",
      ...>   "dvrsen",
      ...>   "enarar"
      ...> ])
      "advent"
  """
  def part_2(messages) do
    messages
    |> Enum.reduce(%{}, fn message, acc ->
      message
      |> String.graphemes
      |> Enum.with_index
      |> Enum.reduce(acc, fn {char, pos}, acc ->
        Map.update(acc, pos, [char], fn list ->
          [char | list]
        end)
      end)
    end)
    |> Enum.map(fn {k, v} ->
      freq = Enum.reduce(v, %{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
      max = Enum.min_by(freq, fn {_, v} ->
        v
      end)
      {k, max}
    end)
    |> Enum.into(%{})
    |> Enum.reduce("", fn {_, v}, acc ->
      acc <> elem(v, 0)
    end)
  end
  
  @doc """
      iex> Day6.part_1([
      ...>   "eedadn",
      ...>   "drvtee",
      ...>   "eandsr",
      ...>   "raavrd",
      ...>   "atevrs",
      ...>   "tsrnev",
      ...>   "sdttsa",
      ...>   "rasrtv",
      ...>   "nssdts",
      ...>   "ntnada",
      ...>   "svetve",
      ...>   "tesnvt",
      ...>   "vntsnd",
      ...>   "vrdear",
      ...>   "dvrsen",
      ...>   "enarar"
      ...> ])
      "easter"
  """
  def part_1(messages) do
    messages
    |> Enum.reduce(%{}, fn message, acc ->
      message
      |> String.graphemes
      |> Enum.with_index
      |> Enum.reduce(acc, fn {char, pos}, acc ->
        Map.update(acc, pos, [char], fn list ->
          [char | list]
        end)
      end)
    end)
    |> Enum.map(fn {k, v} ->
      freq = Enum.reduce(v, %{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
      max = Enum.max_by(freq, fn {_, v} ->
        v
      end)
      {k, max}
    end)
    |> Enum.into(%{})
    |> Enum.reduce("", fn {_, v}, acc ->
      acc <> elem(v, 0)
    end)
  end
end
