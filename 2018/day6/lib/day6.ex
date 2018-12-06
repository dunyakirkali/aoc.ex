defmodule Day6 do
  def part_1(input) do
    coords = input
    |> get_coords
    |> Enum.map(fn {x, y} ->
      {String.to_integer(x), String.to_integer(y)}
    end)
    size = field_size(coords)
    map = make_map(coords, size)
    infinites = get_infinites(map, size)
    maxes = get_maxes(map)
    get_max_count(maxes, infinites)
  end

  def part_2(input, limit) do
    anchors = input
    |> get_coords
    |> Enum.map(fn {x, y} ->
      {String.to_integer(x), String.to_integer(y)}
    end)
    size = field_size(anchors)

    Enum.reduce(0..(elem(size, 0)), [], fn x, acc ->
      Enum.reduce(0..(elem(size, 1)), acc, fn y, acc ->
          [total_distance(anchors, {x, y}) | acc]
      end)
    end)
    |> Enum.filter(fn x ->
      x < limit
    end)
    |> Enum.count
  end

  def total_distance(anchors, point) do
    anchors
    |> Enum.reduce([], fn anchor, acc ->
      [man_dist(anchor, point) | acc]
    end)
    |> Enum.sum
  end

  def make_map(coords, size) do
    map = coords
    |> Enum.with_index
    |> Enum.reduce(%{}, fn {pos, id}, acc ->
      Map.put(acc, pos, id)
    end)

    Enum.reduce(0..(elem(size, 0)), map, fn x, acc ->
      Enum.reduce(0..(elem(size, 1)), acc, fn y, acc ->
        closest = find_closes_anchor({x, y}, coords)
        if closest != nil do
          Map.put(acc, {x, y}, closest)
        else
          acc
        end
      end)
    end)
  end

  def get_maxes(map) do
    Enum.reduce(map, %{}, fn {_, index}, acc ->
      Map.update(acc, index, 1, fn x -> x + 1 end)
    end)
  end

  def get_max_count(areas, infinites) do
    areas
    |> Enum.filter(fn {index, _count} ->
      !Enum.member?(infinites, index)
    end)
    |> Enum.max_by(fn {_index, count} ->
      count
    end)
    |> elem(1)
  end

  def get_infinites(map, size) do
    Enum.reduce(0..(elem(size, 0)), [], fn x, acc ->
      Enum.reduce(0..(elem(size, 1)), acc, fn y, acc ->
        if x == 0 || y == 0 || x == elem(size, 0) || y == elem(size, 1) do
          item = Map.get(map, {x, y})
          if item != nil do
            (acc ++ [item]) |> Enum.uniq
          else
            acc
          end
        else
          acc
        end
      end)
    end)
  end

  def get_coords(input) do
    input
    |> String.trim
    |> String.split("\n")
    |> Enum.map(fn line ->
      line
      |> String.split(", ")
      |> List.to_tuple
    end)
  end

  def find_closes_anchor(point, anchors) do
    distances = anchors
    |> Enum.with_index
    |> Enum.map(fn {anchor, index} ->
      {man_dist(anchor, point), index}
    end)

    rates = distances
    |> Enum.reduce(%{}, fn x, acc -> Map.update(acc, x, 1, &(&1 + 1)) end)
    |> Enum.sort_by(fn {distance, _} -> distance end)

    min = rates |> Enum.min_by(fn {distance, _} -> distance end)
    all_mins = rates |>
    Enum.filter(fn {{distance, _}, _} ->
      distance == elem(min, 0) |> elem(0)
    end)

    if length(all_mins) > 1 do
      nil
    else
      all_mins |> List.first |> elem(0) |> elem(1)
    end
  end

  def man_dist(a, b) do
    abs(elem(a, 0) - elem(b, 0)) + abs(elem(a, 1) - elem(b, 1))
  end

  def field_size(list) do
    max_x = list |> Enum.map(& elem(&1, 0)) |> Enum.max
    max_y = list |> Enum.map(& elem(&1, 1)) |> Enum.max
    {max_x, max_y}
  end
end
