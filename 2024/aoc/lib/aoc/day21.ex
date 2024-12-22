defmodule Aoc.Day21 do
  use Memoize

  @num_keypad Graph.new(type: :directed)
              |> Graph.add_edge("A", "0")
              |> Graph.add_edge("0", "A")
              |> Graph.add_edge("A", "3")
              |> Graph.add_edge("3", "A")
              |> Graph.add_edge("0", "2")
              |> Graph.add_edge("2", "0")
              |> Graph.add_edge("1", "4")
              |> Graph.add_edge("4", "1")
              |> Graph.add_edge("1", "2")
              |> Graph.add_edge("2", "1")
              |> Graph.add_edge("2", "5")
              |> Graph.add_edge("5", "2")
              |> Graph.add_edge("2", "3")
              |> Graph.add_edge("3", "2")
              |> Graph.add_edge("3", "6")
              |> Graph.add_edge("6", "3")
              |> Graph.add_edge("4", "7")
              |> Graph.add_edge("7", "4")
              |> Graph.add_edge("4", "5")
              |> Graph.add_edge("5", "4")
              |> Graph.add_edge("5", "8")
              |> Graph.add_edge("8", "5")
              |> Graph.add_edge("5", "6")
              |> Graph.add_edge("6", "5")
              |> Graph.add_edge("6", "9")
              |> Graph.add_edge("9", "6")
              |> Graph.add_edge("7", "8")
              |> Graph.add_edge("8", "7")
              |> Graph.add_edge("8", "9")
              |> Graph.add_edge("9", "8")

  @dir_keypad Graph.new(type: :directed)
              |> Graph.add_edge("^", "^")
              |> Graph.add_edge("^", "A")
              |> Graph.add_edge("A", "^")
              |> Graph.add_edge("^", "v")
              |> Graph.add_edge("v", "^")
              |> Graph.add_edge("A", ">")
              |> Graph.add_edge(">", "A")
              |> Graph.add_edge("A", "A")
              |> Graph.add_edge("<", "v")
              |> Graph.add_edge("v", "<")
              |> Graph.add_edge("<", "<")
              |> Graph.add_edge("v", ">")
              |> Graph.add_edge(">", "v")
              |> Graph.add_edge("v", "v")
              |> Graph.add_edge(">", ">")

  @doc """
      iex> "priv/day21/example.txt" |> Aoc.Day21.input() |> Aoc.Day21.part1()
      126384
  """
  def part1(codes) do
    codes
    |> Enum.map(fn code ->
      {number, _} = Integer.parse(code)
      length = solve(code, :num, 2)

      length * number
    end)
    |> Enum.sum()
  end

  def part2(codes) do
    codes
    |> Enum.map(fn code ->
      {number, _} = Integer.parse(code)
      length = solve(code, :num, 25)

      length * number
    end)
    |> Enum.sum()
  end

  def solve(line, type, dest) do
    do_solve(line, type, dest + 1, 0)
  end

  defmemo(do_solve(line, _type, dest, depth) when dest == depth, do: String.length(line))

  defmemo do_solve(line, type, dest, depth) do
    line
    |> String.graphemes()
    |> List.insert_at(0, "A")
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.map(fn [from, to] ->
      type
      |> keypad()
      |> Graph.get_paths(from, to)
      |> filter_by_shortest_length()
      |> Enum.map(fn path ->
        path
        |> Enum.chunk_every(2, 1, :discard)
        |> Enum.map(fn step ->
          if type == :num do
            numerical(step)
          else
            directional(step)
          end
        end)
        |> Kernel.++(["A"])
        |> Enum.join()
        |> do_solve(:dir, dest, depth + 1)
      end)
      |> Enum.min()
    end)
    |> Enum.sum()
  end

  def filter_by_shortest_length(lists) do
    # Find the length of the shortest list
    shortest_length = lists |> Enum.map(&length/1) |> Enum.min()

    # Filter the lists by the shortest length
    Enum.filter(lists, fn list -> length(list) == shortest_length end)
  end

  def keypad(:num), do: @num_keypad
  def keypad(:dir), do: @dir_keypad

  def directional(["^", "A"]), do: ">"
  def directional(["^", "v"]), do: "v"
  def directional(["A", "^"]), do: "<"
  def directional(["A", ">"]), do: "v"
  def directional(["<", "v"]), do: ">"
  def directional(["v", "<"]), do: "<"
  def directional(["v", "^"]), do: "^"
  def directional(["v", ">"]), do: ">"
  def directional([">", "A"]), do: "^"
  def directional([">", "v"]), do: "<"
  def directional(["^", "^"]), do: ""
  def directional(["v", "v"]), do: ""
  def directional(["<", "<"]), do: ""
  def directional([">", ">"]), do: ""
  def directional(["A", "A"]), do: ""

  def numerical(["A", "0"]), do: "<"
  def numerical(["A", "3"]), do: "^"
  def numerical(["0", "A"]), do: ">"
  def numerical(["0", "2"]), do: "^"
  def numerical(["1", "4"]), do: "^"
  def numerical(["1", "2"]), do: ">"
  def numerical(["2", "1"]), do: "<"
  def numerical(["2", "3"]), do: ">"
  def numerical(["2", "5"]), do: "^"
  def numerical(["2", "0"]), do: "v"
  def numerical(["3", "2"]), do: "<"
  def numerical(["3", "6"]), do: "^"
  def numerical(["3", "A"]), do: "v"
  def numerical(["4", "7"]), do: "^"
  def numerical(["4", "5"]), do: ">"
  def numerical(["4", "1"]), do: "v"
  def numerical(["5", "4"]), do: "<"
  def numerical(["5", "6"]), do: ">"
  def numerical(["5", "8"]), do: "^"
  def numerical(["5", "2"]), do: "v"
  def numerical(["6", "5"]), do: "<"
  def numerical(["6", "3"]), do: "v"
  def numerical(["6", "9"]), do: "^"
  def numerical(["7", "8"]), do: ">"
  def numerical(["7", "4"]), do: "v"
  def numerical(["8", "7"]), do: "<"
  def numerical(["8", "9"]), do: ">"
  def numerical(["8", "5"]), do: "v"
  def numerical(["9", "8"]), do: "<"
  def numerical(["9", "6"]), do: "v"

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
