defmodule Day12 do
  use Memoize

  @moduledoc """
  Documentation for Day12.
  """

  @pad_size 5

  def part_2(filename, string) do
    lo = Day12.iterate(filename, string, 2000, 0)
    |> sum

    high = Day12.iterate(filename, string, 2001, 0)
    |> sum

    (50_000_000_000 - 2001) * (high - lo) + high
  end

  def pmap(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
  end

  def sum(res) do
    res
    |> elem(0)
    |> String.split("")
    |> Enum.with_index(-1 * elem(res, 1) - 1)
    |> Enum.reduce(0, fn {char, val}, acc ->
      if char == "#", do: acc + val, else: acc
    end)
  end

  def iterate(_, string, 0, index), do: normalize({string, index})
  def iterate(filename, string, generations, index) do
    {string, index} = normalize({string, index})

    codepoints = String.codepoints(string)

    chunks =
      codepoints
      |> Enum.chunk_every(@pad_size, 1, :discard)

    lookedup =
      chunks
      |> pmap(fn list -> Enum.join(list, "") end)
      |> pmap(fn chunk -> lookup(filename, chunk) end)

    next_iteration = Enum.take(codepoints, 2) ++ lookedup ++ Enum.take(codepoints, -2)

    iterate(filename, Enum.join(next_iteration, ""), generations - 1, index)
  end

  @doc """
      iex> Day12.normalize({"#", 0})
      {".....#.....", 5}

      iex> Day12.normalize({"#....", 1})
      {".....#.....", 6}

      iex> Day12.normalize({"....#", -1})
      {".....#.....", 0}

      iex> Day12.normalize({".....#...#....#.....#..#..#..#.....", 5})
      {".....#...#....#.....#..#..#..#.....", 5}
  """
  defmemo normalize(string_and_index) do
    string_and_index
    |> expand_leading
    |> expand_trailing
    |> shrink_leading
    |> shrink_trailing
  end

  @doc """
      iex> Day12.expand_trailing({"#...", 0})
      {"#.....", 0}

      iex> Day12.expand_trailing({"..#...", 3})
      {"..#.....", 3}
  """
  defmemo expand_trailing({string, index}) do
    rev_string = String.reverse(string)
    {shrunk, _} = expand_leading({rev_string, index})
    {String.reverse(shrunk), index}
  end

  @doc """
      iex> Day12.expand_leading({"#", 0})
      {".....#", 5}

      iex> Day12.expand_leading({"#..", 0})
      {".....#..", 5}

      iex> Day12.expand_leading({"...#..", 0})
      {".....#..", 2}

      iex> Day12.expand_leading({"....#.#...#..#.#....#..#..#...#.....", 0})
      {".....#.#...#..#.#....#..#..#...#.....", 1}
  """
  defmemo expand_leading({string, index}) do
    leading_dot_count =
      string
      |> String.codepoints()
      |> Enum.with_index()
      |> Enum.take_while(fn {char, index} ->
        char != "#" && index != @pad_size
      end)
      |> pmap(fn {char, _} -> char end)
      |> Enum.filter(fn x -> x == "." end)
      |> Enum.count()

    if leading_dot_count == 5 do
      {string, index}
    else
      diff = @pad_size - leading_dot_count
      {String.pad_leading(string, String.length(string) + diff, "."), index + diff}
    end
  end

  @doc """
      iex> Day12.shrink_trailing({"......#..........", 0})
      {"......#.....", 0}

      iex> Day12.shrink_trailing({"#.......", 0})
      {"#.....", 0}
  """
  defmemo shrink_trailing({string, index}) do
    rev_string = String.reverse(string)
    {shrunk, _} = shrink_leading({rev_string, index})
    {String.reverse(shrunk), index}
  end

  @doc """
      iex> Day12.shrink_leading({"........#", 0})
      {".....#", -3}

      iex> Day12.shrink_leading({"........#..", 3})
      {".....#..", 0}
  """
  defmemo shrink_leading({string, index}) do
    leading_dot_count =
      string
      |> String.codepoints()
      |> Enum.take_while(fn char -> char != "#" end)
      |> Enum.filter(fn x -> x == "." end)
      |> Enum.count()

    if leading_dot_count == 5 do
      {string, index}
    else
      diff = leading_dot_count - @pad_size
      {String.slice(string, diff..-1), index - diff}
    end
  end

  @doc """
      iex> Day12.lookup("priv/example.txt", "..#..")
      "#"

      iex> Day12.lookup("priv/example.txt", "##.##")
      "#"

      iex> Day12.lookup("priv/example.txt", ".##.#")
      "."

      iex> Day12.lookup("priv/example.txt", "####.")
      "#"
  """
  defmemo lookup(filename, rule) do
    lookup = rules(filename)[rule]

    if lookup == nil do
      "."
    else
      lookup
    end
  end

  defmemo rules(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.filter(fn {_, index} -> index > 0 end)
    |> pmap(fn {line, _} -> String.split(line, " => ") end)
    |> Enum.reduce(%{}, fn [from, to], acc ->
      Map.put(acc, from, to)
    end)
  end

  @doc """
      iex> Day12.initial_state("priv/example.txt")
      "#..#.#..##......###...###"

      iex> Day12.initial_state("priv/input.txt")
      "..##.#######...##.###...#..#.#.#..#.##.#.##....####..........#..#.######..####.#.#..###.##..##..#..#"
  """
  def initial_state(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.filter(fn {_, index} -> index == 0 end)
    |> Enum.map(fn {line, _} -> List.last(String.split(line, ": ")) end)
    |> List.first()
  end
end
