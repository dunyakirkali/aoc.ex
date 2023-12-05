defmodule Aoc.Day5 do
  @doc """
      iex> "priv/day5/example.txt" |> Aoc.Day5.input() |> Aoc.Day5.part1()
      35
  """
  def part1({seeds, rules}) do
    grow(rules, "seed", seeds)
    |> Enum.min()
  end

  @doc """
      iex> "priv/day5/example.txt" |> Aoc.Day5.part2()
      46
  """
  def part2(filename) do
    go(filename |> File.read!())

    # vals =
    #   seeds
    #   |> Enum.chunk_every(2)
    #   |> Enum.map(fn [start, length] -> [start, start + length - 1] end)
    #   |> IO.inspect(label: "seeds")
    #
    # rules
    # |> IO.inspect(label: "rules")
    #
    # grow2(rules, "seed", vals)
    #
    # # Example 1
    # intersection =
    #   MapSet.intersection(
    #     MapSet.new([20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]),
    #     MapSet.new([22, 23, 24, 25, 26, 27, 28])
    #   )
    #   |> IO.inspect(label: "intersection")
    #
    # MapSet.union(
    #   MapSet.new([20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30]),
    #   MapSet.new([22, 23, 24, 25, 26, 27, 28])
    # )
    # |> MapSet.difference(intersection)
    # |> IO.inspect(label: "disjoints")
    #
    # # Example 2
    # intersection =
    #   MapSet.intersection(
    #     MapSet.new([50, 51, 52, 53]),
    #     MapSet.new([52, 53, 54, 55, 56, 57])
    #   )
    #   |> IO.inspect(label: "intersection")
    #
    # MapSet.union(
    #   MapSet.new([50, 51, 52, 53]),
    #   MapSet.new([52, 53, 54, 55, 56, 57])
    # )
    # |> MapSet.difference(intersection)
    # |> IO.inspect(label: "disjoints")
  end

  def grow2(_rules, "location", vals), do: vals

  def grow2(rules, state, vals) do
  end

  def fkey("seed"), do: "seed-to-soil"
  def fkey("soil"), do: "soil-to-fertilizer"
  def fkey("fertilizer"), do: "fertilizer-to-water"
  def fkey("water"), do: "water-to-light"
  def fkey("light"), do: "light-to-temperature"
  def fkey("temperature"), do: "temperature-to-humidity"
  def fkey("humidity"), do: "humidity-to-location"

  def next("seed"), do: "soil"
  def next("soil"), do: "fertilizer"
  def next("fertilizer"), do: "water"
  def next("water"), do: "light"
  def next("light"), do: "temperature"
  def next("temperature"), do: "humidity"
  def next("humidity"), do: "location"

  def grow(_rules, "location", vals), do: vals

  def grow(rules, state, vals) do
    tr =
      Map.get(rules, fkey(state))

    vals =
      vals
      |> Enum.map(fn val ->
        calc(tr, val)
      end)

    grow(rules, next(state), vals)
  end

  def calc(tr, val) do
    fi =
      Enum.find_index(tr, fn trr ->
        source = Enum.at(trr, 1)
        Enum.member?(source, val)
      end)

    if fi == nil do
      val
    else
      [drange, srange] = Enum.at(tr, fi)
      Enum.at(drange, Enum.find_index(srange, fn x -> x == val end))
    end
  end

  def input(filename) do
    groups =
      filename
      |> File.read!()
      |> String.split("\n\n", trim: true)

    sl = Enum.at(groups, 0)

    seeds =
      String.split(sl, ": ")
      |> Enum.at(1)
      |> String.split(" ")
      |> Enum.map(fn ina -> String.to_integer(ina) end)

    rules = List.delete_at(groups, 0)

    pr =
      rules
      |> Enum.map(fn rule ->
        [rn, ts] = String.split(rule, " map:\n", trim: true)

        tss =
          ts
          |> String.split("\n", trim: true)
          |> Enum.map(fn line ->
            [drs, srs, len] =
              String.split(line, " ", trim: true)
              |> Enum.map(fn it -> String.to_integer(it) end)

            [Range.new(drs, drs + len - 1), Range.new(srs, srs + len - 1)]
          end)

        {rn, tss}
      end)
      |> Enum.into(%{})

    {seeds, pr}
  end

  def go(input) do
    ["seeds: " <> seeds | maps] =
      input
      |> String.split("\n\n", trim: true)

    seeds =
      seeds
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
      |> Enum.chunk_every(2)
      |> Enum.map(fn [start, length] ->
        start..(start + (length - 1))
      end)

    maps =
      maps
      |> Enum.reduce([], fn map, acc ->
        [_name | lines] = String.split(map, "\n", trim: true)

        new_map =
          lines
          |> Enum.reduce(%{}, fn nums, ac ->
            [dest, source, length] = String.split(nums) |> Enum.map(&String.to_integer/1)
            Map.put(ac, source..(source + (length - 1)), dest - source)
          end)

        [new_map | acc]
      end)
      |> Enum.reverse()

    Enum.reduce(maps, seeds, fn map, seeds ->
      seeds
      |> Enum.reduce([], fn range, acc ->
        map
        |> Map.keys()
        |> Enum.reduce({[range], []}, fn s..f = r, {ranges, ac} ->
          Enum.reduce(ranges, {[], ac}, fn start..finish, {untouched, transformed} ->
            diff = Map.get(map, r, :error_invariant)

            cond do
              Range.disjoint?(r, start..finish) ->
                {[start..finish | untouched], transformed}

              # s < start
              s < start and f == start ->
                {[(start + 1)..finish | untouched],
                 [Range.shift(start..start, diff) | transformed]}

              s < start and f < finish ->
                {[(f + 1)..finish | untouched], [Range.shift(start..f, diff) | transformed]}

              s < start and f == finish ->
                {untouched, [Range.shift(start..finish, diff) | transformed]}

              s < start and f > finish ->
                {untouched, [Range.shift(start..finish, diff) | transformed]}

              # s == start
              s == start and f == start ->
                {[(f + 1)..finish | untouched], [Range.shift(start..f, diff) | transformed]}

              s == start and f < finish ->
                {[(f + 1)..finish | untouched], [Range.shift(start..f, diff) | transformed]}

              s == start and f == finish ->
                {untouched, [Range.shift(start..finish, diff) | transformed]}

              s == start and f > finish ->
                {untouched, [Range.shift(start..finish, diff) | transformed]}

              # s > start
              s > start and f < finish ->
                {[start..(s - 1), (f + 1)..finish | untouched],
                 [Range.shift(s..f, diff) | transformed]}

              s > start and f == finish ->
                {[start..(s - 1) | untouched], [Range.shift(s..finish, diff) | transformed]}

              s > start and f > finish ->
                {[start..(s - 1) | untouched], [Range.shift(s..finish, diff) | transformed]}

              # s == finish
              s == finish and f == finish ->
                {[start..(finish - 1) | untouched], [Range.shift(s..finish, diff) | transformed]}

              s == finish and f > finish ->
                {[start..(finish - 1) | untouched], [Range.shift(s..finish, diff) | transformed]}
            end
          end)
        end)
        |> then(fn {untouched, transformed} -> untouched ++ transformed ++ acc end)
      end)
    end)
    |> Enum.flat_map(fn s..f -> [s, f] end)
    |> Enum.min()
  end
end
