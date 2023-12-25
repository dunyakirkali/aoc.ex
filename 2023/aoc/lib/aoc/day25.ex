defmodule Aoc.Day25 do
  @doc """
      iex> "priv/day25/example.txt" |> Aoc.Day25.input() |> Aoc.Day25.part1()
      54
  """
  def part1(g) do
    Graph.edges(g)
    |> Comb.combinations(3)
    |> Enum.with_index()
    |> Enum.find(fn {edges, index} ->
      IO.puts(index)

      sg =
        edges
        |> Enum.map(fn edge -> {edge.v1, edge.v2} end)
        |> then(fn edges ->
          Graph.delete_edges(g, edges)
        end)

      edges
      |> Enum.map(fn edge ->
        nv1 =
          Graph.reachable(sg, [edge.v1])
          |> MapSet.new()

        nv2 =
          Graph.reachable(sg, [edge.v2])
          |> MapSet.new()

        MapSet.disjoint?(nv1, nv2)
      end)
      |> Enum.all?()
    end)
    |> then(fn {edges, _} ->
      edge = List.first(edges)

      sg =
        edges
        |> Enum.map(fn edge -> {edge.v1, edge.v2} end)
        |> then(fn edges ->
          Graph.delete_edges(g, edges)
        end)

      (Enum.count(Graph.reachable(sg, [edge.v1])) + 1) *
        (Enum.count(Graph.reachable(sg, [edge.v2])) + 1)
    end)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [f, ts] = String.split(line, ": ", trim: true)

      {f, String.split(ts, " ", trim: true)}
    end)
    |> Enum.reduce(Graph.new(type: :undirected), fn {f, ts}, acc ->
      ts
      |> Enum.reduce(acc, fn t, acc ->
        Graph.add_edge(acc, String.to_atom(f), String.to_atom(t))
      end)
    end)
  end
end
