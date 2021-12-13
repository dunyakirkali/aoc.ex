defmodule Aoc.Day10 do
  def part1() do
    points = parse_points()

    points
    |> Enum.map(fn {{x1, y1}, _} ->
      hit_count =
        Enum.map(points, fn {{x2, y2}, _} ->
          dx = x2 - x1
          dy = y2 - y1

          :math.atan2(dy, dx)
        end)
        |> Enum.uniq
        |> Enum.count

      {{x1, y1}, hit_count}
    end)
    |> Enum.max_by(fn {_, hit_count} ->
      hit_count
    end)
    |> elem(1)
  end

  @doc """
      iex> Aoc.Day10.part2("priv/day10/example_1.txt", {11,13})
      802
  """
  def part2(filename, {x1, y1}) do
    points = parse_points(filename)
    {x, y} =
      points
      |> Enum.map(fn {{x2, y2}, _} ->
        {{x2, y2}, angle({x1, y1}, {x2, y2})}
      end)
      |> Enum.group_by(fn {_, angle} ->
        angle
      end)
      |> Enum.sort_by(fn {angle, _} ->
        angle
      end)
      |> Enum.map(fn {angle, points} ->
        {
          angle,
          Enum.sort_by(points, fn {{x, y}, atan2} ->
            Distance.distance({x1, y1}, {x, y})
          end)
        }
      end)
      |> reduce(0, 0, nil)
      |> elem(0)
    x * 100 + y
  end

  @doc """
      iex> Aoc.Day10.angle({1, 1}, {0, 1})
      270.0

      iex> Aoc.Day10.angle({1, 1}, {2, 1})
      90.0

      iex> Aoc.Day10.angle({1, 1}, {1, 0})
      0.0

      iex> Aoc.Day10.angle({1, 1}, {1, 2})
      180.0
  """
  def angle({x1, y1}, {x2, y2}) do
    dx = x2 - x1
    dy = y2 - y1

    deg = (:math.atan2(dy, dx) * 180.0 / :math.pi) + 90
    deg =
      if deg < 0 do
        deg + 360
      else
        deg
      end
    if deg == 360.0 do
      0.0
    else
      deg
    end
  end

  def reduce(list, index, count, p) when count == 200, do: p
  def reduce(list, index, count, p) do
    {pos, as_at_angle} = Enum.at(list, index)

    if Enum.count(as_at_angle) == 0 do
      list = List.delete_at(list, index)
      index = rem(index + 1, Enum.count(list))
      reduce(list, index, count, p)
    else
      p = Enum.at(as_at_angle, 0)
      as_at_angle = List.delete_at(as_at_angle, 0)
      list = List.replace_at(list, index, {pos, as_at_angle})
      index = rem(index + 1, Enum.count(list))
      {{x, y}, a} = p
      reduce(list, index, count + 1, p)
    end
  end

  defp parse_points(filename \\ "priv/day10/input.txt") do
    input(filename)
    |> Enum.with_index
    |> Enum.reduce(Map.new, fn {line, y}, acc ->
      line
      |> Enum.with_index
      |> Enum.reduce(acc, fn {elem, x}, acc ->
        Map.put(acc, {x, y}, elem)
      end)
    end)
    |> Enum.filter(fn {{x, y}, val} ->
      val == "#"
    end)
    |> Enum.into(%{})
  end

  # @doc """
  #     iex> Aoc.Day10.part2()
  #     nil
  # """
  # def part2() do
  #
  # end

  defp input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      String.split(line, "", trim: true)
    end)
  end
end
