defmodule Aoc.Day6 do
  use Memoize

  @doc """
      iex> Aoc.Day6.part1("priv/day6/example.txt")
      42
  """
  def part1(filename) do
    tree = parse_tree(filename)

    tree
    |> all()
    |> Enum.map(fn x ->
      depth(tree, x, 0)
    end)
    |> Enum.sum
  end

  @doc """
      iex> Aoc.Day6.part2("priv/day6/san.txt")
      4
  """
  def part2(filename) do
    tree = parse_tree(filename)

    graph =
      tree
      |> all()
      |> Enum.reduce(Graph.new(type: :undirected), fn x, acc ->
        Graph.add_vertex(acc, x)
      end)

    graph =
      tree
      |> Enum.reduce(graph, fn {parent, children}, acc ->
        children
        |> Enum.reduce(acc, fn child, accc ->
          Graph.add_edge(accc, child, parent)
        end)
      end)

    Graph.info(graph)

    graph
    |> find("YOU", "SAN", 0, [])
    |> Kernel.-(2)
  end

  def part2d(filename) do
    tree = parse_tree(filename)

    graph =
      tree
      |> all()
      |> Enum.reduce(:digraph.new(), fn x, acc ->
        :digraph.add_vertex(acc, x)
        acc
      end)

    graph =
      tree
      |> Enum.reduce(graph, fn {parent, children}, acc ->
        children
        |> Enum.reduce(acc, fn child, accc ->
          :digraph.add_edge(accc, child, parent)
          :digraph.add_edge(accc, parent, child)
          accc
        end)
        acc
      end)

    Enum.count(:digraph.get_short_path(graph, "YOU", "SAN")) - 3
  end

  defmemo find(_, from, to, acc, _) when from == to, do: acc
  defmemo find(graph, from, to, acc, visited) do
    Graph.neighbors(graph, from)
    |> Enum.filter(fn x ->
      !Enum.member?(visited, x)
    end)
    |> Enum.map(fn x ->
      find(graph, x, to, acc + 1, [from | visited])
    end)
    |> List.flatten
    |> Enum.sort
    |> List.first
  end

  defp all(tree) do
    tree
    |> Map.keys()
    |> Kernel.++(List.flatten(Map.values(tree)))
    |> Enum.uniq
  end

  defp parse_tree(filename) do
    filename
    |> input()
    |> parse(Map.new)
  end

  defp depth(tree, node, acc) do
    parent = Enum.find(tree, fn {_, val} -> Enum.member?(val, node) end)
    if parent == nil do
      acc
    else
      depth(tree, elem(parent, 0), acc + 1)
    end
  end

  defp parse([], acc), do: acc
  defp parse([[parent | child] | tail], acc) do
    parse(tail, Map.update(acc, parent, child, &(&1 ++ child)))
  end

  defp input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      String.split(x, ")")
    end)
  end

  def bench do
    Benchee.run(
      %{
        "BF" => fn -> part2("priv/day6/input.txt") end,
        "Dijkstra" => fn -> part2d("priv/day6/input.txt") end
      },
      formatters: [
        Benchee.Formatters.HTML,
        Benchee.Formatters.Console
      ]
    )

    :ok
  end
end
