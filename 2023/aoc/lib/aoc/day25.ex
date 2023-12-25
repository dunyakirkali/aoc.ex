defmodule Aoc.Day25 do
  @doc """
      iex> "priv/day25/example.txt" |> Aoc.Day25.input() |> Aoc.Day25.part1()
      54
  """
  def part1(g) do
    g
    |> Graph.vertices()
    |> Comb.combinations(2)
    |> Enum.take_random(100_000)
    |> Stream.flat_map(fn [from, to] ->
      case Graph.get_shortest_path(g, from, to) do
        nil -> []
        path -> Enum.chunk_every(path, 2, 1, :discard)
      end
    end)
    |> Enum.reduce(%{}, fn edge, acc ->
      Map.update(acc, Enum.sort(edge), 1, fn e -> e + 1 end)
    end)
    |> Enum.sort(fn {_, lhs}, {_, rhs} -> lhs > rhs end)
    |> Enum.take(20)
    |> Enum.map(fn {p, _} -> List.to_tuple(p) end)
    |> Comb.combinations(3)
    |> Enum.reduce_while(1, fn edges, acc ->
      sg =
        Graph.delete_edges(g, edges)

      res =
        edges
        |> Enum.all?(fn {f, t} ->
          nv1 =
            Graph.reachable(sg, [f])
            |> MapSet.new()

          nv2 =
            Graph.reachable(sg, [t])
            |> MapSet.new()

          MapSet.disjoint?(nv1, nv2) and
            Enum.count(nv1) + Enum.count(nv2) == Graph.num_vertices(sg)
        end)

      if res do
        {f, t} = List.first(edges)

        nv1 =
          Graph.reachable(sg, [f])
          |> MapSet.new()

        nv2 =
          Graph.reachable(sg, [t])
          |> MapSet.new()

        {:halt, Enum.count(nv1) * Enum.count(nv2)}
      else
        {:cont, acc}
      end
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
