defmodule Aoc.Day19 do
  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn
      line ->
        matches =
          ~r/Blueprint (?<blueprint>\d+): Each ore robot costs (?<ore_ore>\d+) ore\. Each clay robot costs (?<clay_ore>\d+) ore\. Each obsidian robot costs (?<obsidian_ore>\d+) ore and (?<obsidian_clay>\d+) clay. Each geode robot costs (?<geode_ore>\d+) ore and (?<geode_obsidian>\d+) obsidian\./
          |> Regex.named_captures(line)
          |> Enum.map(fn {k, v} -> {k, String.to_integer(v)} end)
          |> Enum.into(%{})

        %{
          :id => matches["blueprint"],
          :ore => %{:ore => matches["ore_ore"]},
          :clay => %{:ore => matches["clay_ore"]},
          :obsidian => %{:clay => matches["obsidian_clay"], :ore => matches["obsidian_ore"]},
          :geode => %{:obsidian => matches["geode_obsidian"], :ore => matches["geode_ore"]}
        }
    end)
  end

  @doc """
      iex> "priv/day19/example.txt" |> Aoc.Day19.input() |> Aoc.Day19.part1()
      33
  """
  def part1(blueprints) do
    blueprints
    |> Aoc.Parallel.pmap(&solve(&1, 24))
    |> Enum.with_index()
    |> Enum.map(fn {max_geode, index} ->
      max_geode * (index + 1)
    end)
    |> Enum.sum()
  end

  def solve(blueprint, minutes) do
    best = 0
    state = {0, 0, 0, 0, 1, 0, 0, 0, minutes}
    queue = Deque.new(100_000_000)
    queue = Deque.append(queue, state)
    seen = MapSet.new()

    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while({best, queue, seen}, fn _, {best, queue, set} ->
      case Deque.popleft(queue) do
        {nil, _} -> {:halt, best}
        {state, queue} -> do_solve(state, best, queue, set, blueprint)
      end
    end)
  end

  def do_solve(state, best, queue, set, blueprint) do
    {o, c, ob, g, r1, r2, r3, r4, t} = state

    best = max(best, g)

    if t == 0 do
      {:cont, {best, queue, set}}
    else
      max_ore =
        Enum.max([
          blueprint.ore.ore,
          blueprint.clay.ore,
          blueprint.obsidian.ore,
          blueprint.geode.ore
        ])

      r1 = if r1 >= max_ore, do: max_ore, else: r1
      r2 = if r2 >= blueprint.obsidian.clay, do: blueprint.obsidian.clay, else: r2
      r3 = if r3 >= blueprint.geode.obsidian, do: blueprint.geode.obsidian, else: r3
      o = if o >= t * max_ore - r1 * (t - 1), do: t * max_ore - r1 * (t - 1), else: o

      c =
        if c >= t * blueprint.obsidian.clay - r2 * (t - 1),
          do: t * blueprint.obsidian.clay - r2 * (t - 1),
          else: c

      ob =
        if ob >= t * blueprint.geode.obsidian - r3 * (t - 1),
          do: t * blueprint.geode.obsidian - r3 * (t - 1),
          else: ob

      state = {o, c, ob, g, r1, r2, r3, r4, t}

      if MapSet.member?(set, state) do
        {:cont, {best, queue, set}}
      else
        set = MapSet.put(set, state)

        queue = Deque.append(queue, {o + r1, c + r2, ob + r3, g + r4, r1, r2, r3, r4, t - 1})

        queue =
          if o >= blueprint.ore.ore,
            do:
              Deque.append(
                queue,
                {o - blueprint.ore.ore + r1, c + r2, ob + r3, g + r4, r1 + 1, r2, r3, r4, t - 1}
              ),
            else: queue

        queue =
          if o >= blueprint.clay.ore,
            do:
              Deque.append(
                queue,
                {o - blueprint.clay.ore + r1, c + r2, ob + r3, g + r4, r1, r2 + 1, r3, r4, t - 1}
              ),
            else: queue

        queue =
          if o >= blueprint.obsidian.ore and c >= blueprint.obsidian.clay,
            do:
              Deque.append(
                queue,
                {o - blueprint.obsidian.ore + r1, c - blueprint.obsidian.clay + r2, ob + r3,
                 g + r4, r1, r2, r3 + 1, r4, t - 1}
              ),
            else: queue

        queue =
          if o >= blueprint.geode.ore and ob >= blueprint.geode.obsidian,
            do:
              Deque.append(
                queue,
                {o - blueprint.geode.ore + r1, c + r2, ob - blueprint.geode.obsidian + r3, g + r4,
                 r1, r2, r3, r4 + 1, t - 1}
              ),
            else: queue

        {:cont, {best, queue, set}}
      end
    end
  end

  @doc """
      iex> "priv/day19/example.txt" |> Aoc.Day19.input() |> Aoc.Day19.part2()
      3472
  """
  def part2(blueprints) do
    blueprints
    |> Enum.take(3)
    |> Aoc.Parallel.pmap(&solve(&1, 32))
    |> Enum.reduce(1, fn x, acc -> x * acc end)
  end
end
