defmodule Aoc.Day20 do
  use Memoize
  @doc """
      iex> Aoc.Day20.part1("priv/day20/example_1.txt")
      23

      iex> Aoc.Day20.part1("priv/day20/example_2.txt")
      58
  """
  def part1(filename) do
    map =
      input(filename)
      |> mapify()

    s = size(map) |> IO.inspect(label: "--")
    graph =
      map
      |> graphify()
      |> connect_portals(map, s)
    solve(graph, start(map, s), out(map, s))
  end

  defp connect_portals(graph, map, size) do
    map
    |> portals(size)
    |> Enum.filter(fn {k, _} ->
      k != "AA" and k != "ZZ"
    end)
    |> IO.inspect
    |> Enum.reduce(graph, fn {k, values}, acc ->
      from = Enum.at(values, 0)
      to = Enum.at(values, 1)
      :digraph.add_edge(acc, from, to)
      :digraph.add_edge(acc, to, from)

      acc
    end)
  end

  defp solve(graph, from, to) do
    :digraph.get_short_path(graph, from, to)
    |> Enum.count
    |> Kernel.-(1)
  end

  defp start(map, size) do
    map
    |> portals(size)
    |> Map.get("AA")
    |> Enum.at(0)
  end

  defp out(map, size) do
    map
    |> portals(size)
    |> Map.get("ZZ")
    |> Enum.at(0)
  end

  def size(map) do
    y =
      map
      |> Enum.map(fn {{_, y}, _} ->
        y
      end)
      |> Enum.max
      |> Kernel.+(1)
    x =
      map
      |> Enum.map(fn {{x, _}, _} ->
        x
      end)
      |> Enum.max
      |> Kernel.+(1)
    {x, y}
  end

  defmemo portals(map, {max_x, max_y}) do
    points = for x <- 0..(max_x - 1), y <- 0..(max_y - 1), do: {x, y}
    verticals =
      points
      |> Stream.chunk_every(3, 1, :discard)
      |> Stream.filter(fn [a, b, c] ->
        x = Map.get(map, a)
        y = Map.get(map, b)
        z = Map.get(map, c)
        Regex.match?(~r/([A-Z][A-Z]path|path[A-Z][A-Z])/, "#{x}#{y}#{z}")
      end)
      |> Stream.map(fn [a, b, c] ->
        x = Map.get(map, a)
        y = Map.get(map, b)
        z = Map.get(map, c)

        if Regex.match?(~r/[A-Z][A-Z]path/, "#{x}#{y}#{z}") do
          {"#{x}#{y}", c}
        else
          {"#{y}#{z}", a}
        end
      end)
      |> Enum.reduce(Map.new, fn {name, pos}, acc ->
        curr = Map.get(acc, name, [])
        Map.put(acc, name, [pos | curr])
      end)

    points = for y <- 0..(max_y - 1), x <- 0..(max_x - 1), do: {x, y}
    horizontals =
      points
      |> Stream.chunk_every(3, 1, :discard)
      |> Stream.filter(fn [a, b, c] ->
        x = Map.get(map, a)
        y = Map.get(map, b)
        z = Map.get(map, c)
        Regex.match?(~r/([A-Z][A-Z]path|path[A-Z][A-Z])/, "#{x}#{y}#{z}")
      end)
      |> Stream.map(fn [a, b, c] ->
        x = Map.get(map, a)
        y = Map.get(map, b)
        z = Map.get(map, c)

        if Regex.match?(~r/[A-Z][A-Z]path/, "#{x}#{y}#{z}") do
          {"#{x}#{y}", c}
        else
          {"#{y}#{z}", a}
        end
      end)
      |> Enum.reduce(Map.new, fn {name, pos}, acc ->
        curr = Map.get(acc, name, [])
        Map.put(acc, name, [pos | curr])
      end)

    Map.merge(horizontals, verticals, fn _k, v1, v2 ->
      v1 ++ v2
    end)
    |> IO.inspect(label: "Portal")
  end

  defp graphify(map) do
    graph =
      map
      |> Enum.reduce(:digraph.new(), fn {{x, y}, value}, acc ->
        if value == :path do
          :digraph.add_vertex(acc, {x, y}, value)
        end
        acc
      end)

    graph =
      map
      |> Enum.reduce(graph, fn {{x, y}, _}, acc ->

        if Map.get(map, {x-1, y}, :void) == :path do
          :digraph.add_edge(acc, {x-1, y}, {x, y})
          :digraph.add_edge(acc, {x, y}, {x-1, y})
        end

        if Map.get(map, {x+1, y}, :void) == :path do
          :digraph.add_edge(acc, {x+1, y}, {x, y})
          :digraph.add_edge(acc, {x, y}, {x+1, y})
        end

        if Map.get(map, {x, y-1}, :void) == :path do
          :digraph.add_edge(acc, {x, y-1}, {x, y})
          :digraph.add_edge(acc, {x, y}, {x, y-1})
        end

        if Map.get(map, {x, y+1}, :void) == :path do
          :digraph.add_edge(acc, {x, y+1}, {x, y})
          :digraph.add_edge(acc, {x, y}, {x, y+1})
        end

        acc
      end)
  end

  defp mapify(rows_cols) do
    rows_cols
    |> Stream.with_index
    |> Enum.reduce(Map.new, fn {row, y}, acc ->
      row
      |> Stream.with_index
      |> Enum.reduce(acc, fn {item, x}, acc ->
        Map.put(acc, {x, y}, type(item))
      end)
    end)
  end

  defp type(" "), do: :void
  defp type("#"), do: :wall
  defp type("."), do: :path
  defp type(other), do: other

  defp input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Stream.map(fn x ->
      String.split(x, "", trim: true)
    end)
  end
end
