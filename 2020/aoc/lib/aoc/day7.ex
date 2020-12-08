# TODO: (dunyakirkali) Solve using digraph
defmodule Aoc.Day7 do
  @doc """
      iex> inp = Aoc.Day7.input("priv/day7/example.txt")
      ...> Aoc.Day7.part1(inp)
      4

      iex> inp = Aoc.Day7.input("priv/day7/example2.txt")
      ...> Aoc.Day7.part1(inp)
      0
  """
  def part1(inp) do
    graph =
      inp
      |> Enum.reduce(:digraph.new(), fn row, acc ->
        regex =
          ~r/(?<outer_color>[a-z ]+) bags contain|(?<inner_count>[\d]+) (?<inner_color>[a-z ]+) bag/

        [[_, outer_color] | contents] = Regex.scan(regex, row, capture: :all)

        :digraph.add_vertex(acc, outer_color)

        for [_, _, inner_count, inner_color] <- contents do
          :digraph.add_vertex(acc, inner_color)
          :digraph.add_edge(acc, inner_color, outer_color, String.to_integer(inner_count))
        end

        acc
      end)

    :digraph_utils.reachable(["shiny gold"], graph)
    |> Enum.count
    |> Kernel.-(1)
  end

  @doc """
      iex> inp = Aoc.Day7.input("priv/day7/example.txt")
      ...> Aoc.Day7.part2(inp)
      32

      # iex> inp = Aoc.Day7.input("priv/day7/example2.txt")
      # ...> Aoc.Day7.part2(inp)
      # 126
  """
  def part2(inp) do
    graph =
      inp
      |> Enum.reduce(:digraph.new(), fn row, acc ->
        regex =
          ~r/(?<outer_color>[a-z ]+) bags contain|(?<inner_count>[\d]+) (?<inner_color>[a-z ]+) bag/

        [[_, outer_color] | contents] = Regex.scan(regex, row, capture: :all)

        :digraph.add_vertex(acc, outer_color)

        for [_, _, inner_count, inner_color] <- contents do
          :digraph.add_vertex(acc, inner_color)
          :digraph.add_edge(acc, outer_color, inner_color, String.to_integer(inner_count))
        end

        acc
      end)

    total_containers(graph, "shiny gold", 1)
    |> Kernel.-(1)
  end

  def total_containers(graph, bag_color, current_count) do
    count =
      :digraph.out_edges(graph, bag_color)
      |> Enum.map(fn out_edge ->
        :digraph.edge(graph, out_edge)
      end)
      |> Enum.map(fn {_, _, out_v, out_count} ->
        current_count * total_containers(graph, out_v, out_count)
      end)
      |> Enum.sum()

    current_count + count
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
