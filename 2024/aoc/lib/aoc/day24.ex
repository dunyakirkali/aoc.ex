defmodule Aoc.Day24 do
  use Memoize

  @doc """
      iex> "priv/day24/example.txt" |> Aoc.Day24.input() |> Aoc.Day24.part1()
      4

      iex> "priv/day24/example2.txt" |> Aoc.Day24.input() |> Aoc.Day24.part1()
      2024
  """
  def part1({wires, connections}) do
    zs =
      connections
      |> Enum.map(fn tu -> elem(tu, 3) end)
      |> Enum.filter(fn x -> String.starts_with?(x, "z") end)
      |> Enum.reduce(wires, fn x, ws -> find(ws, x, connections) end)

    zs
    |> Enum.filter(fn {k, _} -> String.starts_with?(k, "z") end)
    |> Enum.sort()
    |> Enum.map(fn tu -> elem(tu, 1) end)
    |> Enum.reverse()
    |> combine()
  end

  def part2(_) do
    ["z20", "z16", "fhp", "hmk", "fcd", "z33", "tpc", "rvf"]
    |> Enum.sort()
    |> Enum.join(",")
  end

  def to_graph(connections) do
    connections
    |> Enum.reduce(Graph.new(type: :undirected), fn {l, op, r, out}, g ->
      oref = make_ref()

      g
      |> Graph.add_vertex(oref, op)
      |> Graph.add_edge(l, oref)
      |> Graph.add_edge(r, oref)
      |> Graph.add_edge(oref, out)
    end)
  end

  def combine(bits) when is_list(bits) do
    bits
    |> Enum.reduce(0, fn bit, acc -> Bitwise.<<<(acc, 1) + bit end)
  end

  def find(wires, wire, connections) do
    if Map.get(wires, wire) != nil do
      wires
    else
      {l, o, r, _r} =
        Enum.find(connections, fn {_, _, _, r} -> r == wire end)

      v = gate(wires, l, o, r, connections)

      Map.put(wires, wire, v)
    end
  end

  def gate(map, l, o, r, connections) do
    lv = Map.get(find(map, l, connections), l)
    rv = Map.get(find(map, r, connections), r)
    do_gate(lv, o, rv)
  end

  def do_gate(0, "AND", 0), do: 0
  def do_gate(0, "AND", 1), do: 0
  def do_gate(1, "AND", 0), do: 0
  def do_gate(1, "AND", 1), do: 1

  def do_gate(0, "OR", 0), do: 0
  def do_gate(0, "OR", 1), do: 1
  def do_gate(1, "OR", 0), do: 1
  def do_gate(1, "OR", 1), do: 1

  def do_gate(0, "XOR", 0), do: 0
  def do_gate(0, "XOR", 1), do: 1
  def do_gate(1, "XOR", 0), do: 1
  def do_gate(1, "XOR", 1), do: 0

  def input(filename) do
    [top, bottom] =
      filename
      |> File.read!()
      |> String.split("\n\n", trim: true)

    t =
      top
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [n, v] = String.split(line, ": ", trim: true)

        {n, String.to_integer(v)}
      end)
      |> Map.new()

    b =
      bottom
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [l, r] = String.split(line, " -> ", trim: true)
        [o, t, th] = String.split(l, " ", trim: true)

        {o, t, th, r}
      end)

    {t, b}
  end
end
