# TODO: (dunyakirkali) Solve
defmodule Aoc.Day17 do
  @cycles 6

  @doc """
      iex> Aoc.Day17.part1("priv/day17/example.txt")
      112
  """
  def part1(inp) do
    chart =
      inp
      |> Aoc.Chart.new()

    width = Aoc.Chart.number_of_cols(chart)

    chart
    |> shift()
    |> cycle(0, width)
    |> count_active()
  end

  def shift(chart) do
    chart
    |> Enum.map(fn {{x, y}, val} ->
      {{x - 1, y - 1, 0}, val}
    end)
    |> Enum.into(%{})
  end

  def shift2(chart) do
    chart
    |> Enum.map(fn {{x, y}, val} ->
      {{x - 1, y - 1, 0, 0}, val}
    end)
    |> Enum.into(%{})
  end

  @doc """
      iex> chart = "priv/day17/example.txt" |> Aoc.Chart.new()
      ...> chart |> Aoc.Day17.count_active
      5
  """
  def count_active(chart) do
    chart
    |> Enum.reduce(0, fn {_, val}, acc ->
      if val == "#" do
        acc + 1
      else
        acc
      end
    end)
  end

  @doc """
      iex> chart = "priv/day17/example.txt" |> Aoc.Chart.new()
      ...> chart |> Aoc.Day17.shift |> Aoc.Day17.cycle(0, 3, 1) |> Aoc.Day17.count_active()
      11
  """
  def cycle(chart, count, width, max \\ @cycles) do
    if count == max do
      chart
    else
      nei =
        {0, 0, 0}
        |> neighbours(count + width)

      [{0, 0, 0} | nei]
      |> Enum.reduce(%{}, fn point, acc ->
        nc =
          point
          |> neighbours()
          |> Enum.map(fn n ->
            Map.get(chart, n, ".")
          end)
          |> Enum.count(fn x ->
            x == "#"
          end)

        if Map.get(chart, point, ".") == "#" do
          if nc == 2 or nc == 3 do
            Map.put(acc, point, "#")
          else
            Map.put(acc, point, ".")
          end
        else
          if nc == 3 do
            Map.put(acc, point, "#")
          else
            Map.put(acc, point, ".")
          end
        end
      end)
      |> cycle(count + 1, width, max)
    end
  end

  @doc """
      iex> Aoc.Day17.neighbours({0, 0, 0}) |> Enum.count
      26

      iex> Aoc.Day17.neighbours({0, 0, 0})
      [
        {-1, -1, -1},
        {-1, -1, 0},
        {-1, -1, 1},
        {-1, 0, -1},
        {-1, 0, 0},
        {-1, 0, 1},
        {-1, 1, -1},
        {-1, 1, 0},
        {-1, 1, 1},
        {0, -1, -1},
        {0, -1, 0},
        {0, -1, 1},
        {0, 0, -1},
        {0, 0, 1},
        {0, 1, -1},
        {0, 1, 0},
        {0, 1, 1},
        {1, -1, -1},
        {1, -1, 0},
        {1, -1, 1},
        {1, 0, -1},
        {1, 0, 0},
        {1, 0, 1},
        {1, 1, -1},
        {1, 1, 0},
        {1, 1, 1}
      ]
  """
  def neighbours({x, y, z}, size \\ 1) do
    for(
      dx <- (-1 * size)..size,
      dy <- (-1 * size)..size,
      dz <- (-1 * size)..size,
      do: {dx, dy, dz}
    )
    |> Enum.map(fn {dx, dy, dz} ->
      if dx == 0 && dy == 0 && dz == 0 do
        nil
      else
        {x + dx, y + dy, z + dz}
      end
    end)
    |> Enum.reject(fn x ->
      x == nil
    end)
  end

  @doc """
      iex> Aoc.Day17.part2("priv/day17/example.txt")
      848
  """
  def part2(inp) do
    chart =
      inp
      |> Aoc.Chart.new()

    width = Aoc.Chart.number_of_cols(chart)

    chart
    |> shift2()
    |> cycle2(0, width)
    |> count_active()
  end

  def cycle2(chart, count, width, max \\ @cycles) do
    if count == max do
      chart
    else
      nei =
        {0, 0, 0, 0}
        |> neighbours2(count + width)

      [{0, 0, 0, 0} | nei]
      |> Enum.reduce(%{}, fn point, acc ->
        nc =
          point
          |> neighbours2()
          |> Enum.map(fn n ->
            Map.get(chart, n, ".")
          end)
          |> Enum.count(fn x ->
            x == "#"
          end)

        if Map.get(chart, point, ".") == "#" do
          if nc == 2 or nc == 3 do
            Map.put(acc, point, "#")
          else
            Map.put(acc, point, ".")
          end
        else
          if nc == 3 do
            Map.put(acc, point, "#")
          else
            Map.put(acc, point, ".")
          end
        end
      end)
      |> cycle2(count + 1, width, max)
    end
  end

  @doc """
      iex> Aoc.Day17.neighbours2({0, 0, 0, 0}) |> Enum.count
      80
  """
  def neighbours2({x, y, z, w}, size \\ 1) do
    for(
      dx <- (-1 * size)..size,
      dy <- (-1 * size)..size,
      dz <- (-1 * size)..size,
      dw <- (-1 * size)..size,
      do: {dx, dy, dz, dw}
    )
    |> Aoc.Parallel.pmap(fn {dx, dy, dz, dw} ->
      if dx == 0 && dy == 0 && dz == 0 && dw == 0 do
        nil
      else
        {x + dx, y + dy, z + dz, w + dw}
      end
    end)
    |> Enum.reject(fn x ->
      x == nil
    end)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n\n", trim: true)
  end
end
