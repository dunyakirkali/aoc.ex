defmodule Aoc.Day11 do
  @doc """
      iex> Aoc.Day11.part1("priv/day11/example.txt")
      37
  """
  def part1(inp) do
    inp
    |> Aoc.Chart.new()
    |> gol(1, 1)
    |> Enum.reduce(0, fn {_, val}, count ->
      if val == "#" do
        count + 1
      else
        count
      end
    end)
  end

  def gol(chart, change, step) do
    if change == 0 do
      chart
    else
      {chart, changed} = apply(chart)
      gol(chart, changed, step + 1)
    end
  end

  def apply(chart) do
    chart
    |> Enum.reduce({%{}, 0}, fn {pos, seat}, {nc, count} ->
      if seat == "L" && check_n(chart, pos) == 0 do
        {Map.put(nc, pos, "#"), count + 1}
      else
        if seat == "#" && check_n(chart, pos) >= 4 do
          {Map.put(nc, pos, "L"), count + 1}
        else
          {Map.put(nc, pos, seat), count}
        end
      end
    end)
  end

  def check_n(chart, {x, y}) do
    top_left = Map.get(chart, {x - 1, y - 1}, nil)
    top = Map.get(chart, {x, y - 1}, nil)
    top_right = Map.get(chart, {x + 1, y - 1}, nil)

    left = Map.get(chart, {x - 1, y}, nil)
    right = Map.get(chart, {x + 1, y}, nil)

    bot_left = Map.get(chart, {x - 1, y + 1}, nil)
    bot = Map.get(chart, {x, y + 1}, nil)
    bot_right = Map.get(chart, {x + 1, y + 1}, nil)

    [top_left, top, top_right, left, right, bot_left, bot, bot_right]
    |> Enum.filter(fn n ->
      n == "#"
    end)
    |> Enum.count()
  end

  def check_v(chart, {x, y}) do
    top_left = check_direction(chart, {x, y}, {-1, -1}, 1)
    top = check_direction(chart, {x, y}, {0, -1}, 1)
    top_right = check_direction(chart, {x, y}, {1, -1}, 1)

    left = check_direction(chart, {x, y}, {-1, 0}, 1)
    right = check_direction(chart, {x, y}, {1, 0}, 1)

    bot_left = check_direction(chart, {x, y}, {-1, 1}, 1)
    bot = check_direction(chart, {x, y}, {0, 1}, 1)
    bot_right = check_direction(chart, {x, y}, {1, 1}, 1)

    [top_left, top, top_right, left, right, bot_left, bot, bot_right]
    |> Enum.filter(fn n ->
      n == "#"
    end)
    |> Enum.count()
  end

  def check_direction(chart, {x, y}, {dx, dy}, radius) do
    val = Map.get(chart, {x + dx * radius, y + dy * radius}, nil)

    if val != "." do
      val
    else
      check_direction(chart, {x, y}, {dx, dy}, radius + 1)
    end
  end

  @doc """
      iex> Aoc.Day11.part2("priv/day11/example.txt")
      26
  """
  def part2(inp) do
    inp
    |> Aoc.Chart.new()
    |> gol2(1, 1)
    |> Enum.reduce(0, fn {_, val}, count ->
      if val == "#" do
        count + 1
      else
        count
      end
    end)
  end

  def gol2(chart, change, step) do
    if change == 0 do
      chart
    else
      {chart, changed} = apply2(chart)
      gol2(chart, changed, step + 1)
    end
  end

  def apply2(chart) do
    chart
    |> Enum.reduce({%{}, 0}, fn {pos, seat}, {nc, count} ->
      if seat == "L" && check_v(chart, pos) == 0 do
        {Map.put(nc, pos, "#"), count + 1}
      else
        if seat == "#" && check_v(chart, pos) >= 5 do
          {Map.put(nc, pos, "L"), count + 1}
        else
          {Map.put(nc, pos, seat), count}
        end
      end
    end)
  end
end
