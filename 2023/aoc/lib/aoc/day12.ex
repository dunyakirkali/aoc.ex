defmodule Aoc.Day12 do
  use Agent
  use Memoize

  def start() do
    Agent.start_link(fn -> [] end, name: :VA)
  end

  @doc """
      iex> "priv/day12/example.txt" |> Aoc.Day12.input() |> Aoc.Day12.part1()
      21
  """
  def part1(list) do
    list
    |> Stream.map(fn row ->
      option_count(row)
    end)
    |> Enum.sum()
  end

  @doc """
      iex> ["#", ".", "#", ".", "#", "#", "#"] |> Aoc.Day12.measure()
      [1, 1, 3]
  """
  defmemo measure(row) do
    row
    |> Enum.join()
    |> String.split(~r/\.+/, trim: true)
    |> Enum.map(fn grp -> String.length(grp) end)
  end

  @doc """
      iex> "???.### 1,1,3" |> Aoc.Day12.parse |> Aoc.Day12.expand()
      [[".", ".", ".", ".", "#", "#", "#"],[".", ".", "#", ".", "#", "#", "#"],[".", "#", ".", ".", "#", "#", "#"],["#", ".", ".", ".", "#", "#", "#"],["#", ".", "#", ".", "#", "#", "#"],["#", "#", "#", ".", "#", "#", "#"]]
  """
  defmemo expand({option, score}) do
    start()
    do_expand(option, Enum.reverse(score), [])
    ret = Agent.get(:VA, & &1)
    Agent.update(:VA, fn _ -> [] end)
    ret
  end

  def do_expand([], _, acc), do: Agent.update(:VA, &(&1 ++ [Enum.reverse(acc)]))

  def do_expand(["." | t], score, acc) do
    ns = measure(acc)
    diff = List.myers_difference(ns, score)

    if Keyword.has_key?(diff, :del) or Enum.count(ns) > Enum.count(score) do
      []
    else
      do_expand(t, score, ["." | acc])
    end
  end

  def do_expand(["#" | t], score, acc) do
    do_expand(t, score, ["#" | acc])
  end

  def do_expand(["?" | t], score, acc) do
    Enum.map([".", "#"], fn ch ->
      ns = measure(acc)
      diff = List.myers_difference(ns, score)

      if ch == "." and (Keyword.has_key?(diff, :del) or Enum.count(ns) > Enum.count(score)) do
        []
      else
        do_expand(t, score, [ch | acc])
      end
    end)
  end

  @doc """
      iex> "???.### 1,1,3" |> Aoc.Day12.parse |> Aoc.Day12.option_count()
      1

      iex> ".??..??...?##. 1,1,3" |> Aoc.Day12.parse |> Aoc.Day12.option_count()
      4

      iex> "?#?#?#?#?#?#?#? 1,3,1,6" |> Aoc.Day12.parse |> Aoc.Day12.option_count()
      1

      iex> "????.#...#... 4,1,1" |> Aoc.Day12.parse |> Aoc.Day12.option_count()
      1

      iex> "????.######..#####. 1,6,5" |> Aoc.Day12.parse |> Aoc.Day12.option_count()
      4

      iex> "?###???????? 3,2,1" |> Aoc.Day12.parse |> Aoc.Day12.option_count()
      10
  """
  def option_count({_, scores} = row) do
    row
    |> expand()
    |> Enum.count(fn opt -> measure(opt) == scores end)
  end

  @doc """
      iex> "priv/day12/example.txt" |> Aoc.Day12.input() |> Aoc.Day12.part2()
      525152
  """
  def part2(list) do
    list
    |> Enum.map(fn item ->
      item
      |> unfold()
      |> count()
    end)
    |> Enum.sum()
  end

  @doc """
      iex> "???.### 1,1,3" |> Aoc.Day12.parse |> Aoc.Day12.count()
      1

      iex> ".??..??...?##. 1,1,3" |> Aoc.Day12.parse |> Aoc.Day12.count()
      4

      iex> "?#?#?#?#?#?#?#? 1,3,1,6" |> Aoc.Day12.parse |> Aoc.Day12.count()
      1

      iex> "????.#...#... 4,1,1" |> Aoc.Day12.parse |> Aoc.Day12.count()
      1

      iex> "????.######..#####. 1,6,5" |> Aoc.Day12.parse |> Aoc.Day12.count()
      4

      iex> "?###???????? 3,2,1" |> Aoc.Day12.parse |> Aoc.Day12.count()
      10
  """
  defmemo(count({[], []}), do: 1)
  defmemo(count({[], _}), do: 0)
  defmemo(count({option, []}), do: if(Enum.member?(option, "#"), do: 0, else: 1))

  defmemo count({[oh | ot] = option, [sh | st] = scores}) do
    result =
      if Enum.member?([".", "?"], oh) do
        count({ot, scores})
      else
        0
      end

    if Enum.member?(["#", "?"], oh) do
      if sh <= Enum.count(option) and not Enum.member?(Enum.take(option, sh), ".") and
           (sh == Enum.count(option) or Enum.at(option, sh) != "#") do
        result + count({Enum.drop(option, sh + 1), st})
      else
        result
      end
    else
      result
    end
  end

  @doc """
      iex> ".# 1" |> Aoc.Day12.parse |> Aoc.Day12.unfold()
      {[".", "#", "?", ".", "#", "?", ".", "#", "?", ".", "#", "?", ".", "#"], [1, 1, 1, 1, 1]}

      iex> "???.### 1,1,3" |> Aoc.Day12.parse |> Aoc.Day12.unfold()
      {["?", "?", "?", ".", "#", "#", "#", "?", "?", "?", "?", ".", "#", "#", "#", "?", "?", "?", "?", ".", "#", "#", "#", "?", "?", "?", "?", ".", "#", "#", "#", "?", "?", "?", "?", ".", "#", "#", "#"], [1, 1, 3, 1, 1, 3, 1, 1, 3, 1, 1, 3, 1, 1, 3]}
  """
  def unfold({option, scores}) do
    uo =
      option
      |> List.duplicate(5)
      |> Enum.reduce([], fn lst, acc ->
        acc ++ lst ++ ["?"]
      end)
      |> then(fn x ->
        List.delete_at(x, length(x) - 1)
      end)

    us =
      List.duplicate(scores, 5)
      |> List.flatten()

    {uo, us}
  end

  def parse(line) do
    [h, t] = String.split(line, " ", trim: true)
    springs = String.graphemes(h)

    pieces =
      t
      |> String.split(",", trim: true)
      |> Enum.map(&String.to_integer/1)

    {springs, pieces}
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&parse/1)
  end
end
