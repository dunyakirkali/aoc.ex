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
      iex> "priv/day5/example.txt" |> Aoc.Day5.input() |> Aoc.Day5.part2()
      46
  """
  def part2({seeds, rules}) do
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
end
