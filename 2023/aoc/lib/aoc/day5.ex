defmodule Aoc.Day5 do
  use Memoize

  @doc """
      iex> "priv/day5/example.txt" |> Aoc.Day5.input() |> Aoc.Day5.part1()
      35
  """
  def part1({seeds, rules}) do
    grow(rules, "seed", seeds)
    |> Enum.min()
  end

  def aert(x, rules) do
    {:cond, [],
     [
       [
         {:do,
          Enum.map(rules, fn [dr, sr] ->
            condition(Enum.at(dr, 0), Enum.at(sr, 0), Enum.count(dr), x)
          end)}
       ]
     ]}
  end

  @doc """
      iex> "priv/day5/example.txt" |> Aoc.Day5.input() |> Aoc.Day5.part2()
      46
  """
  def part2({seeds, rules}) do
    aert(42, Map.get(rules, "seed-to-soil"))
    |> Macro.to_string()
    |> IO.inspect()

    # condition(50, 98, 2, 99)
    # trea(51)
    # |> IO.inspect()
    # |> Macro.to_string()
    # |> IO.inspect(label: "AST")

    # |> Code.eval_quoted()

    # |> IO.inspect(label: "AST")
    # |> Code.eval_quoted()
    # |> IO.inspect(label: "Eval")

    seeds
    |> seed_ranges()
    |> Enum.count()

    # |> Stream.flat_map(fn v ->
    #   grow(rules, "seed", [v])
    # end)
    # |> Enum.min()
  end

  def condition(drs, srs, rl, val) do
    {:->, [],
     [
       [
         {:and, [context: Aoc.Day5, imports: [{2, Kernel}]],
          [
            {:<=, [context: Aoc.Day5, imports: [{2, Kernel}]],
             to_charlist([srs, {val, [], Aoc.Day5}])},
            {:<, [context: Aoc.Day5, imports: [{2, Kernel}]],
             to_charlist([{val, [], Aoc.Day5}, srs + rl])}
          ]}
       ],
       {:+, [context: Aoc.Day5, imports: [{1, Kernel}, {2, Kernel}]],
        to_charlist([{val, [], Aoc.Day5}, drs - srs])}
     ]}
  end

  def trea(x) do
    quote do
      cond do
        98 <= unquote(x) and unquote(x) < 100 ->
          unquote(x) - 48

        50 <= unquote(x) and unquote(x) < 52 ->
          unquote(x) + 2

        true ->
          unquote(x)
      end
    end
  end

  def seed_ranges(seeds) do
    seeds
    |> Stream.chunk_every(2)
    |> Stream.flat_map(fn [sr, len] -> Range.new(sr, sr + len - 1) |> Enum.to_list() end)
    |> Stream.uniq()
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
    state |> IO.inspect(label: "state")

    tr =
      Map.get(rules, fkey(state))

    vals =
      vals
      |> Enum.map(fn val ->
        calc(tr, val)
      end)

    grow(rules, next(state), vals)
  end

  defmemo calc(tr, val) do
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
      |> IO.inspect(label: "seeds")

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
