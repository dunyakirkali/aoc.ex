defmodule ListRotation do
  def left_rotate(l, n \\ 1)
  def left_rotate([], _), do: []
  def left_rotate(l, 0), do: l
  def left_rotate([h | t], 1), do: t ++ [h]
  def left_rotate(l, n) when n > 0, do: left_rotate(left_rotate(l, 1), n - 1)
  def left_rotate(l, n), do: right_rotate(l, -n)

  def right_rotate(l, n \\ 1)

  def right_rotate(l, n) when n > 0,
    do: Enum.reverse(l) |> ListRotation.left_rotate(n) |> Enum.reverse()

  def right_rotate(l, n), do: left_rotate(l, -n)
end

defmodule Aoc.Day23 do
  def input(filename) do
    filename
    |> File.read!()
    |> Aoc.Chart.new()
  end

  @doc """
      iex> "priv/day23/mini.txt" |> Aoc.Day23.input() |> Aoc.Day23.part1()
      25

      iex> "priv/day23/example.txt" |> Aoc.Day23.input() |> Aoc.Day23.part1()
      110
  """
  def part1(chart) do
    # chart |> Aoc.Chart.draw()

    1..10
    |> Enum.reduce(chart, fn round, acc ->
      # round |> IO.inspect(label: "Round")
      proposals = propose(acc, round - 1)

      {acc, moved} = move(acc, proposals)
      acc
      # |> Aoc.Chart.draw()
    end)
    |> score
  end

  def score(chart) do
    {minx, maxx} =
      chart
      |> Map.keys()
      |> Enum.map(&elem(&1, 0))
      |> Enum.min_max()

    # |> IO.inspect(label: "xs")

    {miny, maxy} =
      chart
      |> Map.keys()
      |> Enum.map(&elem(&1, 1))
      |> Enum.min_max()

    # |> IO.inspect(label: "ys")

    elves = elves(chart)

    full = (maxy - miny + 1) * (maxx - minx + 1)
    full - Enum.count(elves)
  end

  def move(chart, proposals) do
    frequencies =
      proposals
      # |> IO.inspect(label: "proposals")
      |> Enum.map(fn {{c, r}, {co, ro}} ->
        {c + co, r + ro}
      end)
      |> Enum.frequencies()

    elves = elves(chart)

    do_move(chart, elves, frequencies, proposals, 0)
  end

  def do_move(chart, [], _, _, moved), do: {chart, moved}

  def do_move(chart, [{{c, r}, _} | t], frequencies, proposals, moved) do
    if Map.get(proposals, {c, r}) == nil do
      do_move(chart, t, frequencies, proposals, moved)
    else
      {dc, dr} = Map.get(proposals, {c, r})

      if Map.get(frequencies, {c + dc, r + dr}) == 1 do
        chart
        |> Map.put({c, r}, ".")
        |> Map.put({c + dc, r + dr}, "#")
        |> do_move(t, frequencies, proposals, moved + 1)
      else
        do_move(chart, t, frequencies, proposals, moved)
      end
    end
  end

  def elves(map) do
    map
    |> Enum.filter(fn {_, v} ->
      v == "#"
    end)
  end

  def propose(chart, round) do
    elves = elves(chart)

    do_propose(chart, elves, [], round)
    |> Enum.into(%{})
  end

  def do_propose(_, [], proposals, _), do: proposals

  def do_propose(chart, [{{c, r}, _} | t], proposals, round) do
    # IO.inspect({c, r}, label: "Elf at")
    # Aoc.Chart.draw(chart)
    # score(chart)
    cn =
      [{-1, -1}, {0, -1}, {1, -1}]
      |> Enum.all?(fn {dc, dr} ->
        Map.get(chart, {c + dc, r + dr}, ".") == "."
      end)

    cs =
      [{-1, 1}, {0, 1}, {1, 1}]
      |> Enum.all?(fn {dc, dr} ->
        # {c + dc, r + dr} |> IO.inspect(label: "GRR")
        # Map.get(chart, {c + dc, r + dr}, ".") |> IO.inspect(label: "WAT")
        Map.get(chart, {c + dc, r + dr}, ".") == "."
      end)

    cw =
      [{-1, -1}, {-1, 0}, {-1, 1}]
      |> Enum.all?(fn {dc, dr} ->
        Map.get(chart, {c + dc, r + dr}, ".") == "."
      end)

    ce =
      [{1, -1}, {1, 0}, {1, 1}]
      |> Enum.all?(fn {dc, dr} ->
        Map.get(chart, {c + dc, r + dr}, ".") == "."
      end)

    option =
      [cn, cs, cw, ce]
      |> ListRotation.left_rotate(round)
      |> Enum.with_index()
      |> Enum.map(fn {c, ind} ->
        if c do
          case rem(ind + round, 4) do
            0 -> {0, -1}
            1 -> {0, 1}
            2 -> {-1, 0}
            3 -> {1, 0}
          end
        else
          nil
        end
      end)
      |> Enum.reject(fn v ->
        v == nil
      end)
      |> List.first()

    # |> dbg

    if option == nil or (cn and cs and cw and ce) do
      do_propose(chart, t, proposals, round)
    else
      do_propose(chart, t, [{{c, r}, option} | proposals], round)
    end
  end

  @doc """
      iex> "priv/day23/example.txt" |> Aoc.Day23.input() |> Aoc.Day23.part2()
      20
  """
  def part2(chart) do
    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while(chart, fn round, acc ->
      proposals = propose(acc, round)

      {acc, moved} = move(acc, proposals)

      if moved == 0 do
        {:halt, round + 1}
      else
        {:cont, acc}
      end
    end)
  end
end
