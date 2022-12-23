defmodule Aoc.Day23 do
  def input(filename) do
    filename
    |> File.read!()
    |> Aoc.Chart.new()
  end

  @doc """
      iex> "priv/day23/mini.txt" |> Aoc.Day23.input() |> Aoc.Day23.part1()
      110

      # iex> "priv/day23/example.txt" |> Aoc.Day23.input() |> Aoc.Day23.part1()
      # 110
  """
  def part1(chart) do
    chart |> Aoc.Chart.draw()

    1..10
    |> Enum.reduce(chart, fn step, acc ->
      proposals = propose(acc)

      acc
      |> move(proposals)
      |> Aoc.Chart.draw()
    end)
    |> score
  end

  def score(chart) do
    {minx, maxx} =
      chart
      |> Map.keys()
      |> Enum.map(&elem(&1, 0))
      |> Enum.min_max()

    {miny, maxy} =
      chart
      |> Map.keys()
      |> Enum.map(&elem(&1, 1))
      |> Enum.min_max()

    elves = elves(chart)

    full = (maxy - miny) * (maxx - minx)
    full - Enum.count(elves)
  end

  def move(chart, proposals) do
    frequencies =
      proposals
      |> Enum.flat_map(fn {{c, r}, opts} ->
        opts
        |> Enum.map(fn {dc, dr} ->
          {c + dc, r + dr}
        end)
      end)
      |> Enum.frequencies()

    elves = elves(chart)

    do_move(chart, elves, frequencies, proposals)
  end

  def do_move(chart, [], _, _), do: chart

  def do_move(chart, [{{c, r}, v} | t], frequencies, proposals) do
    # p |> IO.inspect(label: "elf")
    options = proposals |> Map.get({c, r})

    can_move =
      Enum.all?(options, fn {dc, dr} ->
        Map.get(frequencies, {c + dc, r + dr}) == 1
      end)

    if can_move do
      options
      |> Enum.reduce_while(chart, fn {dc, dr}, acc ->
        # IO.inspect(Map.get(frequencies, pro), label: "Frew")
        if Map.get(frequencies, {c + dc, r + dr}) == 1 do
          {:halt,
           acc
           |> Map.put({c, r}, ".")
           |> Map.put({c + dc, r + dr}, "#")}
        else
          {:cont, acc}
        end
      end)
      |> do_move(t, frequencies, proposals)
    else
      do_move(chart, t, frequencies, proposals)
    end
  end

  def elves(map) do
    map
    |> Enum.filter(fn {_, v} ->
      v == "#"
    end)
  end

  def propose(chart) do
    elves = elves(chart)

    do_propose(chart, elves, [])
    |> Enum.into(%{})
  end

  def do_propose(chart, [], proposals), do: proposals

  def do_propose(chart, [{{c, r}, _} | t], proposals) do
    cn =
      [{-1, -1}, {0, -1}, {1, -1}]
      |> Enum.map(fn {dc, dr} ->
        Map.get(chart, {c + dc, r + dr}, ".")
      end)
      |> Enum.all?(fn v ->
        v == "."
      end)

    cs =
      [{-1, 1}, {0, 1}, {1, 1}]
      |> Enum.map(fn {dc, dr} ->
        Map.get(chart, {c + dc, r + dr}, ".")
      end)
      |> Enum.all?(fn v ->
        v == "."
      end)

    ce =
      [{1, -1}, {1, 0}, {1, 1}]
      |> Enum.map(fn {dc, dr} ->
        Map.get(chart, {c + dc, r + dr}, ".")
      end)
      |> Enum.all?(fn v ->
        v == "."
      end)

    cw =
      [{-1, -1}, {-1, 0}, {-1, 1}]
      |> Enum.map(fn {dc, dr} ->
        Map.get(chart, {c + dc, r + dr}, ".")
      end)
      |> Enum.all?(fn v ->
        v == "."
      end)

    options =
      [cn, cs, cw, ce]
      |> Enum.with_index()
      |> Enum.map(fn {c, ind} ->
        if c do
          case ind do
            0 -> {0, -1}
            1 -> {0, 1}
            2 -> {1, 0}
            3 -> {-1, 0}
          end
        else
          nil
        end
      end)
      |> Enum.reject(fn v ->
        v == nil
      end)

    do_propose(chart, t, [{{c, r}, options} | proposals])
  end

  # @doc """
  #     iex> "priv/day23/example.txt" |> Aoc.Day23.input() |> Aoc.Day23.part2()
  #     301
  # """
  # def part2(numbers) do
  #   numbers
  # end
end
