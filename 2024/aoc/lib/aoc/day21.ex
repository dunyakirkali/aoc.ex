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
      {number, _} =
        code
        |> String.graphemes()
        |> Enum.join()
        |> Integer.parse()
        |> IO.inspect(label: "number")

      Enum.reduce(0..1, solve(code, :num), fn _, acc ->
        acc
        |> Enum.flat_map(fn seq ->
          solve(seq, :dir)
        end)
      end)
      |> Enum.min_by(fn str -> String.length(str) end)
      |> IO.inspect(label: "number")
      |> String.length()
      |> Kernel.*(number)
    end)
    |> Enum.sum()
  end

  def part2(codes) do
    codes
    |> Enum.map(fn code ->
      {number, _} =
        code
        |> String.graphemes()
        |> Enum.join()
        |> Integer.parse()

      # Pre-calculate all possible sequences once
      sequences = solve(code, :num)

      # Find shortest sequence after 25 iterations
      final_sequence =
        Enum.reduce(1..25, sequences, fn i, acc ->
          IO.inspect(i, label: "i")
          Enum.flat_map(acc, &solve(&1, :dir))
        end)
        |> Enum.min_by(&String.length/1)

      # Calculate result
      String.length(final_sequence) * number
    end)
    |> Enum.sum()
  end

  defmemo solve(line, keypad) do
    initial_position = "A"

    movements =
      line
      |> String.graphemes()
      |> build_path_segments(initial_position)
      |> calculate_paths(keypad)
      |> flatten_and_format_paths(keypad)
      |> generate_unique_solutions()
  end

  defp build_path_segments(chars, start_pos) do
    chars
    |> List.insert_at(0, start_pos)
    |> Enum.chunk_every(2, 1, :discard)
  end

  defp calculate_paths(segments, keypad_type) do
    keypad = get_keypad_for_type(keypad_type)

    Enum.map(segments, fn [from, to] ->
      keypad
      |> Graph.get_paths(from, to)
      |> find_shortest_lists()
    end)
  end

  defp flatten_and_format_paths(paths, keypad_type) do
    Enum.map(paths, fn path ->
      path
      |> Enum.chunk_every(2, 1, :discard)
      |> Enum.map(&convert_step(&1, keypad_type))
      |> append_final_position()
      |> find_shortest_lists()
    end)
  end

  defp get_keypad_for_type(:num), do: @num_keypad
  defp get_keypad_for_type(_), do: @dir_keypad

  defp convert_step(step, :num), do: numerical(step)
  defp convert_step(step, _), do: directional(step)

  defp append_final_position(path), do: path ++ ["A"]

  defp generate_unique_solutions(paths) do
    paths
    |> generate()
    |> Enum.uniq()
  end

  def generate(arrays) do
    arrays
    |> Enum.map(fn subarray ->
      subarray
      |> Enum.map(fn x ->
        List.flatten([x]) |> Enum.join()
      end)
    end)
    |> combine_all([])
  end

  defp combine_all([head | tail], []) do
    combine_all(tail, head)
  end

  defp combine_all([head | tail], acc) do
    new_acc =
      for x <- acc,
          y <- head,
          do: x <> y

    combine_all(tail, new_acc)
  end

  defp combine_all([], acc), do: acc

  def find_shortest_lists(lists) do
    min_length =
      lists
      |> Enum.map(&length/1)
      |> Enum.min()

    lists |> Enum.filter(fn list -> length(list) == min_length end)
  end

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
