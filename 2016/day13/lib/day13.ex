defmodule Day13 do
  use Memoize

  def part_2(fav) do
    destinations = for x <- 0..100, y <- 0..100, do: {x, y}

    g = graphy(destinations, Graph.new(), fav)
    g = connect(g)

    Graph.vertices(g)
    |> Enum.map(fn destination ->
      Graph.a_star(g, {1, 1}, destination, fn _v -> 0 end)
    end)
    |> Enum.filter(fn x -> x != nil end)
    |> Enum.filter(fn x -> length(x) < 52 end)
    |> List.flatten
    |> Enum.uniq
    |> Enum.count

  end

  @doc """
      iex> Day13.part_1(10, {7, 4})
      11
  """
  def part_1(fav, {dx, dy}) do
    points = for x <- 0..(dx + 10), y <- 0..(dy + 10), do: {x, y}

    g = graphy(points, Graph.new(), fav)
    g = connect(g)

    Graph.a_star(g, {1, 1}, {dx, dy}, fn _v -> 0 end)
    |> Enum.count
    |> Kernel.-(1)
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

  def graphy(points, graph, fav) when length(points) == 0, do: graph
  def graphy([point | rest], graph, fav) do
    g =
      if space?(point, fav) do
        graph
        |> Graph.add_vertex(point)
      else
        graph
      end
    graphy(rest, g, fav)
  end

  @doc """
      iex> Day13.neighbours({0, 0})
      [{1, 0}, {0, 1}]
  """
  def neighbours({x, y}) do
    [{x + 1, y}, {x, y + 1}, {x - 1, y}, {x, y - 1}]
    |> Enum.filter(fn {x, y} ->
      x > -1 and y > -1
    end)
  end

  @doc """
      iex> Day13.space?({0, 0})
      true

      iex> Day13.space?({1, 1})
      true
  """
  def space?({x, y}, fav \\ 10) do
    formula({x, y})
    |> Kernel.+(fav)
    |> Integer.to_string(2)
    |> String.graphemes
    |> Enum.filter(fn x -> x == "1" end)
    |> Enum.count
    |> Kernel.rem(2)
    |> Kernel.!=(1)
  end

  defp formula({x, y}) do
    x*x + 3*x + 2*x*y + y + y*y
  end
end
