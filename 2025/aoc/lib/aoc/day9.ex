defmodule Aoc.Day9 do
  @doc """
      iex> "priv/day9/example.txt" |> Aoc.Day9.input() |> Aoc.Day9.part1()
      50
  """
  def part1(input) do
    input.vertices
    |> combinations(2)
    |> Enum.map(fn [{x1, y1}, {x2, y2}] ->
      (abs(x1 - x2) + 1) * (abs(y1 - y2) + 1)
    end)
    |> Enum.max()
  end

  @doc """
      iex> "priv/day9/example.txt" |> Aoc.Day9.input() |> Aoc.Day9.part2()
      24
  """
  def part2(input) do
    vertices = input.vertices

    vertex_set = MapSet.new(vertices)
    edges = build_edges(vertices)
    {min_x, max_x, min_y, max_y} = get_bounds(vertices)

    total = div(length(vertices) * (length(vertices) - 1), 2)
    chunk_size = max(100, div(total, System.schedulers_online() * 4))

    vertices
    |> combinations(2)
    |> Enum.chunk_every(chunk_size)
    |> Task.async_stream(
      fn chunk ->
        Enum.reduce(chunk, 0, fn [{x1, y1}, {x2, y2}], max_area ->
          area =
            check_rectangle_optimized(
              x1,
              y1,
              x2,
              y2,
              edges,
              vertex_set,
              min_x,
              max_x,
              min_y,
              max_y
            )

          max(area, max_area)
        end)
      end,
      max_concurrency: System.schedulers_online() * 2,
      timeout: :infinity,
      ordered: false
    )
    |> Enum.reduce(0, fn {:ok, area}, max_area -> max(area, max_area) end)
  end

  defp check_rectangle_optimized(
         x1,
         y1,
         x2,
         y2,
         edges,
         vertex_set,
         poly_min_x,
         poly_max_x,
         poly_min_y,
         poly_max_y
       ) do
    min_x = min(x1, x2)
    max_x = max(x1, x2)
    min_y = min(y1, y2)
    max_y = max(y1, y2)

    if min_x < poly_min_x or max_x > poly_max_x or min_y < poly_min_y or max_y > poly_max_y do
      0
    else
      rect_area = (max_x - min_x + 1) * (max_y - min_y + 1)

      corners = [{min_x, min_y}, {max_x, min_y}, {min_x, max_y}, {max_x, max_y}]

      if Enum.all?(corners, &point_in_polygon_fast(&1, edges, vertex_set)) do
        if rectangle_edges_clear?(min_x, max_x, min_y, max_y, edges, vertex_set) do
          rect_area
        else
          0
        end
      else
        0
      end
    end
  end

  defp rectangle_edges_clear?(min_x, max_x, min_y, max_y, edges, vertex_set) do
    horiz_ok =
      Enum.all?([min_y, max_y], fn y ->
        stride = max(1, div(max_x - min_x, 100))

        Enum.all?(min_x..max_x//stride, fn x ->
          point_in_polygon_fast({x, y}, edges, vertex_set)
        end)
      end)

    if not horiz_ok do
      false
    else
      Enum.all?([min_x, max_x], fn x ->
        stride = max(1, div(max_y - min_y, 100))

        Enum.all?(min_y..max_y//stride, fn y ->
          point_in_polygon_fast({x, y}, edges, vertex_set)
        end)
      end)
    end
  end

  defp point_in_polygon_fast({px, py}, edges, vertex_set) do
    if MapSet.member?(vertex_set, {px, py}) do
      true
    else
      on_edge =
        Enum.any?(edges, fn {{x1, y1}, {x2, y2}} ->
          cond do
            y1 == y2 and py == y1 and px >= min(x1, x2) and px <= max(x1, x2) -> true
            x1 == x2 and px == x1 and py >= min(y1, y2) and py <= max(y1, y2) -> true
            true -> false
          end
        end)

      if on_edge do
        true
      else
        count =
          Enum.reduce(edges, 0, fn {{x1, y1}, {x2, y2}}, acc ->
            if y1 == y2 do
              acc
            else
              {y_min, y_max, x_at_min, _x_at_max} =
                if y1 > y2, do: {y2, y1, x2, x1}, else: {y1, y2, x1, x2}

              if py >= y_min and py < y_max and px < x_at_min do
                acc + 1
              else
                acc
              end
            end
          end)

        rem(count, 2) == 1
      end
    end
  end

  defp build_edges(vertices) do
    vertices
    |> Enum.chunk_every(2, 1, [List.first(vertices)])
    |> Enum.map(fn [p1, p2] -> {p1, p2} end)
  end

  defp get_bounds(vertices) do
    xs = Enum.map(vertices, fn {x, _} -> x end)
    ys = Enum.map(vertices, fn {_, y} -> y end)
    {Enum.min(xs), Enum.max(xs), Enum.min(ys), Enum.max(ys)}
  end

  defp combinations(_, 0), do: [[]]
  defp combinations([], _), do: []

  defp combinations([h | t], k) do
    for(combo <- combinations(t, k - 1), do: [h | combo]) ++ combinations(t, k)
  end

  def input(filename) do
    vertices =
      filename
      |> File.read!()
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [x, y] =
          line
          |> String.split(",", trim: true)
          |> Enum.map(&String.to_integer/1)

        {x, y}
      end)

    %{vertices: vertices}
  end
end
