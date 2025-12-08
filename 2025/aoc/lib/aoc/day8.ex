defmodule Aoc.Day8 do
  @doc """
      iex> "priv/day8/example.txt" |> Aoc.Day8.input() |> Aoc.Day8.part1()
      40
  """
  def part1(l, count \\ 10) do
    l
    |> Enum.map(fn {id, _} -> id end)
    |> Comb.combinations(2)
    |> Enum.map(fn [a, b] ->
      {[a, b], distance(Map.get(l, a), Map.get(l, b))}
    end)
    |> Enum.sort_by(fn {_, d} -> d end)
    |> Enum.take(count)
    |> Enum.reduce(:digraph.new(), fn {[f, t], d}, acc ->
      :digraph.add_vertex(acc, f)
      :digraph.add_vertex(acc, t)
      :digraph.add_edge(acc, f, t, d)
      :digraph.add_edge(acc, t, f, d)
      acc
    end)
    |> island_sizes()
    |> Enum.sort()
    |> Enum.reverse()
    |> Enum.take(3)
    |> Enum.reduce(1, fn x, acc -> x * acc end)
  end

  @doc """
      iex> "priv/day8/example.txt" |> Aoc.Day8.input() |> Aoc.Day8.part2()
      25272
  """
  def part2(l) do
    nc = Enum.count(l)

    l
    |> Enum.map(fn {id, _} -> id end)
    |> Comb.combinations(2)
    |> Enum.map(fn [a, b] ->
      {[a, b], distance(Map.get(l, a), Map.get(l, b))}
    end)
    |> Enum.sort_by(fn {_, d} -> d end)
    |> Enum.reduce_while(:digraph.new(), fn {[f, t], d}, g ->
      :digraph.add_vertex(g, f)
      :digraph.add_vertex(g, t)
      :digraph.add_edge(g, f, t, d)
      :digraph.add_edge(g, t, f, d)

      s = island_sizes(g)

      if Enum.count(s) == 1 and :digraph.no_vertices(g) == nc do
        {:halt, [f, t]}
      else
        {:cont, g}
      end
    end)
    |> Enum.map(fn id -> Map.get(l, id) |> elem(0) end)
    |> Enum.reduce(1, fn x, acc -> x * acc end)
  end

  def island_sizes(graph) do
    :digraph_utils.components(graph)
    |> Enum.map(&length/1)
  end

  defp distance({xa, ya, za}, {xb, yb, zb}) do
    :math.sqrt(:math.pow(xb - xa, 2) + :math.pow(yb - ya, 2) + :math.pow(zb - za, 2))
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.map(fn {line, id} ->
      {id,
       line |> String.split(",", trim: true) |> Enum.map(&String.to_integer/1) |> List.to_tuple()}
    end)
    |> Enum.into(%{})
  end
end
