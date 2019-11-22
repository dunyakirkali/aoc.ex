defmodule Day24 do
  @doc """
      iex> Day24.part_2("priv/example.txt")
      20
  """
  def part_2(filename) do
    graph =
      filename
      |> read()
      |> Enum.with_index()
      |> graphy(Graph.new())
      |> connect()

    graph
    |> Graph.vertices()
    |> Enum.map(fn pos ->
      {Graph.vertex_labels(graph, pos), pos}
    end)
    |> Enum.filter(fn {label, pos} ->
      length(label) > 0
    end)
    |> Combination.permutate
    |> Enum.filter(fn x ->
      ro = List.first(x)
      |> elem(0)
      |> List.first
      |> Kernel.==("0")
    end)
    |> Enum.map(fn x ->
      x ++ [List.first(x)]
    end)
    # |> IO.inspect
    |> Enum.map(fn perm ->
        # perm |> IO.inspect
        Enum.chunk_every(perm, 2, 1, :discard)
        # |> IO.inspect
        |> pmap(fn [from, to] ->
          Graph.a_star(graph, elem(from, 1), elem(to, 1), fn _v -> 0 end)
          |> Enum.count
          |> Kernel.-(1)
        end)
        |> Enum.sum
        |> IO.inspect
    end)
    |> Enum.min
  end

  @doc """
      iex> Day24.part_1("priv/example.txt")
      14
  """
  def part_1(filename) do
    graph =
      filename
      |> read()
      |> Enum.with_index()
      |> graphy(Graph.new())
      |> connect()

    graph
    |> Graph.vertices()
    |> Enum.map(fn pos ->
      {Graph.vertex_labels(graph, pos), pos}
    end)
    |> Enum.filter(fn {label, pos} ->
      length(label) > 0
    end)
    |> Combination.permutate
    |> Enum.filter(fn x ->
      ro = List.first(x)
      |> elem(0)
      |> List.first
      |> Kernel.==("0")
    end)
    # |> IO.inspect
    |> Enum.map(fn perm ->
        # perm |> IO.inspect
        Enum.chunk_every(perm, 2, 1, :discard)
        |> Enum.map(fn [from, to] ->
          Graph.a_star(graph, elem(from, 1), elem(to, 1), fn _v -> 0 end)
          |> Enum.count
          |> Kernel.-(1)
        end)
        |> Enum.sum
        |> IO.inspect
    end)
    |> Enum.min
  end

  defp graphy(rows, graph) when length(rows) == 0, do: graph
  defp graphy([{first_row, y} | rest], graph) do
    g =
      Enum.reduce(Enum.with_index(first_row), graph, fn {col, x}, acc ->
        if col != "#" do
          if col != "." do
            # IO.inspect(col)
            Graph.add_vertex(acc, {x, y}, col)
          else
            Graph.add_vertex(acc, {x, y})
          end
        else
          acc
        end
      end)
    graphy(rest, g)
  end

  def connect(graph) do
  points = Graph.vertices(graph)
  Enum.reduce(points, graph, fn point, acc ->
    left = {elem(point, 0) - 1, elem(point, 1)}
    right = {elem(point, 0) + 1, elem(point, 1)}
    up = {elem(point, 0), elem(point, 1) - 1}
    down = {elem(point, 0), elem(point, 1) + 1}

    [left, down, up, right]
    |> Enum.reduce(acc, fn x, acc ->
      if Enum.member?(points, x) do
        Graph.add_edge(acc, point, x)
      else
        acc
      end
    end)
  end)
end

  defp read(filename) do
    filename
    |> File.read!
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, "", trim: true)
    end)
    # |> IO.inspect
  end

  def pmap(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await/1)
  end
end
