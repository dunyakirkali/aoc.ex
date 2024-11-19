defmodule Aoc.Day25 do
  alias Nx.Stream

  @doc """
      iex> "priv/day25/example.txt" |> Aoc.Day25.input() |> Aoc.Day25.part1()
      54
  """
  def part1(g) do
    # Graph.new(type: :undirected)
    # |> Graph.add_edge(:a, :b, label: 3)

    contract(g)
    |> Graph.edges()
    |> List.first()
  end

  def contract(g) do
    Graph.num_vertices(g)
    |> IO.inspect()

    if Graph.num_vertices(g) > 2 do
      e =
        Graph.edges(g)
        |> Enum.random()
        |> IO.inspect()

      v1 = e.v1
      v2 = e.v2

      nv1 =
        Graph.neighbors(g, v1)
        |> List.delete(v2)
        |> IO.inspect()

      nv2 =
        Graph.neighbors(g, v2)
        |> List.delete(v1)
        |> IO.inspect()

      nv = nv1 ++ nv2

      g = Graph.delete_vertex(g, v1)
      g = Graph.delete_vertex(g, v2)

      vn = "#{v1}_#{v2}" |> String.to_atom()

      g = Graph.add_vertex(g, vn)

      g =
        nv
        |> Enum.frequencies()
        |> Enum.reduce(g, fn {n, freq}, acc ->
          Graph.add_edge(acc, vn, n, label: freq)
        end)

      Graph.num_vertices(g)
      |> IO.inspect()

      contract(g)
    else
      g
    end
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
