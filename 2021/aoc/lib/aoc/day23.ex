defmodule Aoc.Day23 do
  use Memoize

  use Agent

  def start do
    Agent.start_link(fn -> [10_000_000_000_000] end, name: :scores)
    Agent.start_link(fn -> %{} end, name: :visited)
  end

  @costs %{
    "A" => 1,
    "B" => 10,
    "C" => 100,
    "D" => 1000
  }
  @doc """
      iex> input = Aoc.Day23.input("priv/day23/example.txt")
      ...> Aoc.Day23.part1(input)
      12521
  """
  def part1(input) do
    start()
    solve(input, 0, &solved?/1)
  end

  def solve(map, score, solver) do
    state = state(map)
    visited = Agent.get(:visited, &Map.get(&1, state), 1_000_000_000)

    cond do
      score > best_score() ->
        # IO.puts("bbbbbbbbbb")
        score

      visited ->
        # IO.puts("cccccccccc")
        10_000_000_000_000

      true ->
        # map |> print
        Agent.update(:visited, &Map.put(&1, state, true), 1_000_000_000)
        # state|> IO.inspect()
        if solver.(map) do
          Agent.update(:scores, &[score | &1], 1_000_000_000)
          IO.inspect(score, label: "score")
        else
          possible_froms = moves(map)

          Enum.map(possible_froms, fn {from, tos} ->
            tos
            |> Enum.map(fn to ->
              nm = move(map, {from, to})
              solve(nm, score + Map.get(@costs, Map.get(map, from)), solver)
            end)
          end)
        end
    end
  end

  def move(map, {from, to}) do
    fc = Map.get(map, from)

    map
    |> Map.put(from, ".")
    |> Map.put(to, fc)
  end

  def solved?(map) do
    Map.get(map, {3, 2}) == "A" and
      Map.get(map, {3, 3}) == "A" and
      Map.get(map, {5, 2}) == "B" and
      Map.get(map, {5, 3}) == "B" and
      Map.get(map, {7, 2}) == "C" and
      Map.get(map, {7, 3}) == "C" and
      Map.get(map, {9, 2}) == "D" and
      Map.get(map, {9, 3}) == "D"
  end

  def solved3?(map) do
    Map.get(map, {3, 3}) == "A" and
      Map.get(map, {9, 3}) == "B"
  end

  def solved2?(map) do
    Map.get(map, {3, 2}) == "A" and
      Map.get(map, {3, 3}) == "A" and
      Map.get(map, {3, 4}) == "A" and
      Map.get(map, {3, 5}) == "A" and
      Map.get(map, {5, 2}) == "B" and
      Map.get(map, {5, 3}) == "B" and
      Map.get(map, {5, 4}) == "B" and
      Map.get(map, {5, 5}) == "B" and
      Map.get(map, {7, 2}) == "C" and
      Map.get(map, {7, 3}) == "C" and
      Map.get(map, {7, 4}) == "C" and
      Map.get(map, {7, 5}) == "C" and
      Map.get(map, {9, 2}) == "D" and
      Map.get(map, {9, 3}) == "D" and
      Map.get(map, {9, 4}) == "D" and
      Map.get(map, {9, 5}) == "D"
  end

  def state(map) do
    map
    |> Enum.filter(fn {_, char} ->
      char != "." and char != "#" and char != " "
    end)
  end

  @doc """
      # iex> input = Aoc.Day23.input("priv/day23/example3.txt")
      # ...> Aoc.Day23.part2(input)
      # nil
  """
  def part2(input) do
    start()
    solve(input, 0, &solved2?/1)
    best_score()
  end

  def test(input) do
    start()
    # |> IO.inspect()
    solve(input, 0, &solved3?/1) |> List.flatten() |> Enum.sort()
    best_score()
  end

  def best_score() do
    Agent.get(:scores, & &1, 1_000_000_000)
    # |> IO.inspect()
    |> Enum.min()
  end

  def moves(map) do
    map
    |> Enum.filter(fn {_, char} ->
      Enum.member?(["A", "B", "C", "D"], char)
    end)
    |> Enum.map(fn {pos, _} ->
      {pos, neighbors(map, pos)}
    end)
  end

  def print(map) do
    IO.puts("")

    height = Map.keys(map) |> Enum.map(fn {x, _} -> x end) |> Enum.max()
    width = Map.keys(map) |> Enum.map(fn {_, y} -> y end) |> Enum.max()

    Enum.map(0..width, fn row ->
      Enum.map(0..height, fn col ->
        pos = {col, row}
        value = Map.get(map, pos, " ")
        to_string(value)
      end)
      |> Enum.intersperse("")
    end)
    |> Enum.join("\n")
    |> IO.puts()

    map
  end

  def neighbors(map, {x, y}) do
    [
      {x, y - 1},
      {x - 1, y},
      {x + 1, y},
      {x, y + 1}
    ]
    |> Enum.filter(fn pos ->
      Map.get(map, pos) == "."
    end)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, y}, acc ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {char, x}, acc ->
        Map.put(acc, {x, y}, char)
      end)
    end)
  end
end
