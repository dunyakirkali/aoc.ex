defmodule Aoc.Day9 do
  @doc """
      iex> "priv/day9/example.txt" |> Aoc.Day9.input() |> Aoc.Day9.part1()
      50
  """
  def part1(l) do
    l.vertices
    |> Comb.combinations(2)
    |> Enum.map(fn [{x1, y1}, {x2, y2}] ->
      area({x1, y1}, {x2, y2})
    end)
    |> Enum.max()
  end

  @doc """
      iex> "priv/day9/example.txt" |> Aoc.Day9.input() |> Aoc.Day9.part2()
      24
  """
  def part2(l) do
    # Get the ordered vertices (corners) - preserve input order
    vertices = get_vertices_in_order(l)

    # Fill the polygon
    filled = fill_polygon(vertices, l)

    filled
    |> render()
    |> IO.puts()

    l.vertices
    |> Comb.combinations(2)
    |> Enum.map(fn [{x1, y1}, {x2, y2}] ->
      positions =
        for x <- x1..x2, y <- y1..y2 do
          {x, y}
        end

      emc = Enum.all?(positions, fn pos -> Map.get(filled, pos, ".") != "." end)

      if emc do
        positions
        |> MapSet.new()
        |> MapSet.intersection(MapSet.new(Map.keys(filled)))
        |> MapSet.size()
      else
        0
      end
    end)
    |> IO.inspect()
    |> Enum.max()
  end

  def size(m) do
    mx =
      m
      |> Map.keys()
      |> Enum.filter(fn key -> is_tuple(key) end)
      |> Enum.map(fn {x, _} -> x end)
      |> Enum.max()
      |> Kernel.+(2)

    my =
      m
      |> Map.keys()
      |> Enum.filter(fn key -> is_tuple(key) end)
      |> Enum.map(fn {_, y} -> y end)
      |> Enum.max()
      |> Kernel.+(2)

    {mx, my}
  end

  def fill_polygon(vertices, corners_map) do
    # Remove metadata from corners_map for size calculation
    clean_map = Map.delete(corners_map, :vertices)
    {mx, my} = size(clean_map)

    # Create a map with all filled positions
    for y <- 1..my, x <- 1..mx do
      pos = {x, y}

      cond do
        Map.has_key?(clean_map, pos) -> {pos, "#"}
        inside_or_on_polygon?(pos, vertices) -> {pos, "#"}
        true -> nil
      end
    end
    |> Enum.filter(&(&1 != nil))
    |> Map.new()
  end

  defp inside_or_on_polygon?(point, vertices) do
    on_edge?(point, vertices) or inside_polygon?(point, vertices)
  end

  defp on_edge?({x, y}, vertices) do
    vertices
    |> edges()
    |> Enum.any?(fn {{x1, y1}, {x2, y2}} ->
      point_on_segment?(x, y, x1, y1, x2, y2)
    end)
  end

  defp edges(vertices) do
    vertices
    |> Enum.chunk_every(2, 1, [List.first(vertices)])
    |> Enum.map(fn [p1, p2] -> {p1, p2} end)
  end

  defp point_on_segment?(x, y, x1, y1, x2, y2) do
    min_x = min(x1, x2)
    max_x = max(x1, x2)
    min_y = min(y1, y2)
    max_y = max(y1, y2)

    cond do
      y1 == y2 and y == y1 and x >= min_x and x <= max_x -> true
      x1 == x2 and x == x1 and y >= min_y and y <= max_y -> true
      true -> false
    end
  end

  defp inside_polygon?({px, py}, vertices) do
    count =
      vertices
      |> edges()
      |> Enum.reduce(0, fn {{x1, y1}, {x2, y2}}, acc ->
        if y1 == y2 do
          acc
        else
          {y1, y2, x1, x2} = if y1 > y2, do: {y2, y1, x2, x1}, else: {y1, y2, x1, x2}

          cond do
            py < y1 or py >= y2 ->
              acc

            true ->
              x_intersect = x1 + (py - y1) * (x2 - x1) / (y2 - y1)

              if px < x_intersect do
                acc + 1
              else
                acc
              end
          end
        end
      end)

    rem(count, 2) == 1
  end

  def render(map) do
    {mx, my} = size(map)

    for y <- 1..my do
      for x <- 1..mx do
        Map.get(map, {x, y}, ".")
      end
      |> Enum.join()
    end
    |> Enum.join("\n")
  end

  def area({x1, y1}, {x2, y2}) do
    (abs(x1 - x2) + 1) * (abs(y1 - y2) + 1)
  end

  def input(filename) do
    vertices =
      filename
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.map(fn [x, y] -> {x, y} end)

    # Store both the map and the ordered vertices
    map =
      vertices
      |> Enum.reduce(%{}, fn pos, acc ->
        Map.put(acc, pos, "#")
      end)

    # Add metadata with ordered vertices
    Map.put(map, :vertices, vertices)
  end

  def get_vertices_in_order(map) do
    Map.get(map, :vertices, [])
  end
end
