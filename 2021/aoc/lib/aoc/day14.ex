defmodule Aoc.Day14 do
  @doc """
      iex> input = Aoc.Day14.input("priv/day14/example.txt")
      ...> Aoc.Day14.part1(input)
      1588
  """
  def part1([data, map]) do
    1..10
    |> Enum.reduce(data, fn _, data ->
      step(data, map)
    end)
    |> Enum.frequencies()
    |> score()
  end

  def step([char1, char2 | rest], map) do
    [char1, map[char1 <> char2] | step([char2 | rest], map)]
  end

  def step([char], _map), do: [char]

  def step2(data, map) do
    data
    |> Enum.map(fn {<<c1, c2>> = k, v} -> [{<<c1>> <> map[k], v}, {map[k] <> <<c2>>, v}] end)
    |> List.flatten()
    |> Enum.group_by(&elem(&1, 0))
    |> Map.new(fn {k, v} -> {k, v |> Enum.map(&elem(&1, 1)) |> Enum.sum()} end)
  end

  def score(freq) do
    freq
    |> Map.values()
    |> Enum.min_max()
    |> then(fn {min, max} -> max - min end)
  end

  @doc """
      iex> input = Aoc.Day14.input("priv/day14/example.txt")
      ...> Aoc.Day14.part2(input)
      2188189693529
  """
  def part2([data, map]) do
    1..40
    |> Enum.reduce(
      data
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(fn [c1, c2] -> c1 <> c2 end)
      |> Enum.frequencies(),
      fn _, data -> step2(data, map) end
    )
    |> then(fn map ->
      [{<<c, _>>, n} | rest] = Enum.to_list(map)

      rest
      |> Enum.reduce(%{}, fn {<<_, c>>, n}, acc ->
        Map.update(acc, <<c>>, n, &(&1 + n))
      end)
      |> Map.update(<<c>>, n, &(&1 + n))
    end)
    |> score()
  end

  def input(filename) do
    [template, list] =
      filename
      |> File.read!()
      |> String.split("\n\n", trim: true)

    list =
      list
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        String.split(line, " -> ", trim: true)
      end)
      |> Enum.reduce(%{}, fn [k, v], acc ->
        Map.put(acc, k, v)
      end)
      # |> IO.inspect()

  [String.split(template, "", trim: true), list]
  end
end
