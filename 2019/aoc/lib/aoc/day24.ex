defmodule Aoc.Day24 do
  @doc """
      iex> Aoc.Day24.part2("priv/day24/example_2.txt", 10)
      99
  """
  def part2(filename, iterations) do
    map =
      filename
      |> input()
      |> mapify()
      |> Map.put({2, 2}, :rec)

    maps =
      -200..200
      |> Enum.reduce(Map.new, fn level, acc ->
        if level == 0 do
          Map.put(acc, level, map)
        else
          Map.put(acc, level, empty_map)
        end
      end)

    rec_tick(maps, iterations)
    |> Enum.reduce(0, fn {depth, value}, acc ->
      value
      |> Enum.reduce(acc, fn {_, value}, acc ->
        case value do
          :bug ->
            acc + 1
          _ ->
            acc
        end
      end)
    end)
  end

  @doc """
      iex> Aoc.Day24.part1("priv/day24/example_2.txt")
      2129920
  """
  def part1(filename) do
    map =
      filename
      |> input()
      |> mapify()

    tick(map, [])
  end

  def print_fancy(map) do
    map
    |> Enum.reduce(Drawille.Canvas.new(), fn({{x, y}, value}, acc_canvas) ->
      acc_canvas =
        case value do
          _ -> Drawille.Canvas.unset(acc_canvas, x + 1, y + 1)
          :bug -> Drawille.Canvas.set(acc_canvas, x + 1, y + 1)
        end
      acc_canvas
    end)
    |> Drawille.Canvas.frame
    map
  end

  def rec_tick(maps, iter) do
    if iter == 0 do
      maps
    else
      maps
      |> Enum.map(fn {level, map} ->
        map =
          map
          |> Enum.filter(fn {pos, value} ->
            pos != {2, 2}
          end)
          |> Enum.map(fn {pos, value} ->
            neighbour_count =
              rec_neighbours({level, pos})
              |> Stream.filter(fn {level, neighbour} ->
                map_at_level = Map.get(maps, level, empty_map())
                Map.get(map_at_level, neighbour) == :bug
              end)
              |> Enum.count

            cond do
              value == :bug and neighbour_count != 1 ->
                {pos, :space}
              value == :space and (neighbour_count == 1 or neighbour_count == 2) ->
                {pos, :bug}
              true ->
                {pos, value}
            end
          end)
          |> Enum.into(Map.new)

        {level, map}
      end)
      |> Enum.into(Map.new)
      # |> IO.inspect
      |> rec_tick(iter - 1)
    end
  end

  @doc """
      iex> Aoc.Day24.empty_map()
      %{
        {0, 0} => :space,
        {0, 1} => :space,
        {0, 2} => :space,
        {0, 3} => :space,
        {0, 4} => :space,
        {1, 0} => :space,
        {1, 1} => :space,
        {1, 2} => :space,
        {1, 3} => :space,
        {1, 4} => :space,
        {2, 0} => :space,
        {2, 1} => :space,
        {2, 2} => :rec,
        {2, 3} => :space,
        {2, 4} => :space,
        {3, 0} => :space,
        {3, 1} => :space,
        {3, 2} => :space,
        {3, 3} => :space,
        {3, 4} => :space,
        {4, 0} => :space,
        {4, 1} => :space,
        {4, 2} => :space,
        {4, 3} => :space,
        {4, 4} => :space}
  """
  def empty_map() do
    for x <- 0..4, y <- 0..4 do
      if x == 2 and y == 2 do
        {{x, y}, :rec}
      else
        {{x, y}, :space}
      end
    end
    |> Enum.into(Map.new)
  end

  def tick(map, seen) do
    score = biodiversity_rating(map, {5, 5})
    if Enum.member?(seen, score) do
      # print_fancy(map)
      score
    else
      seen = [score | seen]
      map
      |> Enum.map(fn {pos, value} ->
        neighbour_count =
          pos
          |> neighbours()
          |> Stream.filter(fn neighbour ->
            Map.get(map, neighbour, :space) == :bug
          end)
          |> Enum.count

        cond do
          value == :bug and neighbour_count != 1 ->
            {pos, :space}
          value == :space and (neighbour_count == 1 or neighbour_count == 2) ->
            {pos, :bug}
          true ->
            {pos, value}
        end
      end)
      |> Enum.into(Map.new)
      # |> print_fancy()
      |> tick(seen)
    end
  end

  @doc """
      iex> "priv/day24/example_1.txt"
      ...> |> Aoc.Day24.input()
      ...> |> Aoc.Day24.mapify()
      ...> |> Aoc.Day24.biodiversity_rating({5, 5})
      2129920
  """
  def biodiversity_rating(map, {width, _}) do
    map
    |> Enum.reduce(0, fn {{x, y}, value}, acc ->
      acc
      |> Kernel.+(
        case value do
          :bug ->
            trunc(:math.pow(2, x + (y * width)))
          :space ->
            0
        end
      )
    end)
  end

  def mapify(str) do
    do_mapify(str, {0, 0}, Map.new())
  end

  @doc """
      iex> Aoc.Day24.rec_neighbours({0, {3, 3}})
      [{0, {4, 3}}, {0, {2, 3}}, {0, {3, 4}}, {0, {3, 2}}]

      iex> Aoc.Day24.rec_neighbours({1, {1, 1}})
      [
        {1, {2, 1}},
        {1, {0, 1}},
        {1, {1, 2}},
        {1, {1, 0}}
      ]

      iex> Aoc.Day24.rec_neighbours({1, {3, 0}})
      [
        {1, {4, 0}},
        {1, {2, 0}},
        {1, {3, 1}},
        {0, {2, 1}}
      ]

      iex> Aoc.Day24.rec_neighbours({1, {4, 0}})
      [
        {0, {3, 2}},
        {1, {3, 0}},
        {1, {4, 1}},
        {0, {2, 1}}
      ]

      iex> Aoc.Day24.rec_neighbours({0, {3, 2}})
      [
        {0, {4, 2}},
        {1, {4, 0}},
        {1, {4, 1}},
        {1, {4, 2}},
        {1, {4, 3}},
        {1, {4, 4}},
        {0, {3, 3}},
        {0, {3, 1}}
      ]
  """
  def rec_neighbours({level, {x, y}}) when {x, y} in [{1, 1}, {3, 1}, {1, 3}, {3, 3}] do
    [
      {level,     {x + 1, y     }},
      {level,     {x - 1, y     }},
      {level,     {x,     y + 1 }},
      {level,     {x,     y - 1 }}
    ]
  end
  def rec_neighbours({level, {x, y}}) when {x, y} in [{0, 0}] do
    [
      {level,     {x + 1, y     }},
      {level - 1, {1,     2     }},
      {level,     {x,     y + 1 }},
      {level - 1, {2,     1     }}
    ]
  end
  def rec_neighbours({level, {x, y}}) when {x, y} in [{4, 0}] do
    [
      {level - 1, {3,     2     }},
      {level,     {x - 1, y     }},
      {level,     {x,     y + 1 }},
      {level - 1, {2,     1     }}
    ]
  end
  def rec_neighbours({level, {x, y}}) when y == 0 do
    [
      {level,     {x + 1, y     }},
      {level,     {x - 1, y     }},
      {level,     {x,     y + 1 }},
      {level - 1, {2,     1     }}
    ]
  end
  def rec_neighbours({level, {x, y}}) when {x, y} in [{0, 4}] do
    [
      {level,     {x + 1, y     }},
      {level - 1, {1,     2     }},
      {level - 1, {2,     3     }},
      {level,     {x,     y - 1 }}
    ]
  end
  def rec_neighbours({level, {x, y}}) when x == 0 do
    [
      {level,     {x + 1, y     }},
      {level - 1, {1,     2     }},
      {level,     {x,     y + 1 }},
      {level,     {x,     y - 1 }}
    ]
  end
  def rec_neighbours({level, {x, y}}) when {x, y} in [{4, 4}] do
    [
      {level - 1, {3,     2     }},
      {level,     {x - 1, y     }},
      {level - 1, {2,     3     }},
      {level,     {x,     y - 1 }}
    ]
  end
  def rec_neighbours({level, {x, y}}) when x == 4 do
    [
      {level - 1, {3,     2     }},
      {level,     {x - 1, y     }},
      {level,     {x,     y + 1 }},
      {level,     {x,     y - 1 }}
    ]
  end
  def rec_neighbours({level, {x, y}}) when y == 4 do
    [
      {level,     {x + 1, y     }},
      {level,     {x - 1, y     }},
      {level - 1, {2,     3     }},
      {level,     {x,     y - 1 }}
    ]
  end
  def rec_neighbours({level, {x, y}}) when {x, y} in [{2, 1}] do
    [
      {level,     {x + 1, y     }},
      {level,     {x - 1, y     }},
      {level + 1, {0,     0     }},
      {level + 1, {1,     0     }},
      {level + 1, {2,     0     }},
      {level + 1, {3,     0     }},
      {level + 1, {4,     0     }},
      {level,     {x,     y - 1 }}
    ]
  end
  def rec_neighbours({level, {x, y}}) when {x, y} in [{1, 2}] do
    [
      {level + 1, {0,     0     }},
      {level + 1, {0,     1     }},
      {level + 1, {0,     2     }},
      {level + 1, {0,     3     }},
      {level + 1, {0,     4     }},
      {level,     {x - 1, y     }},
      {level,     {x,     y + 1 }},
      {level,     {x,     y - 1 }}
    ]
  end
  def rec_neighbours({level, {x, y}}) when {x, y} in [{2, 3}] do
    [
      {level,     {x + 1, y     }},
      {level,     {x - 1, y     }},
      {level,     {x,     y + 1 }},
      {level + 1, {0,     4     }},
      {level + 1, {1,     4     }},
      {level + 1, {2,     4     }},
      {level + 1, {3,     4     }},
      {level + 1, {4,     4     }}
    ]
  end
  def rec_neighbours({level, {x, y}}) when {x, y} in [{3, 2}] do
    [
      {level,     {x + 1, y     }},
      {level + 1, {4,     0     }},
      {level + 1, {4,     1     }},
      {level + 1, {4,     2     }},
      {level + 1, {4,     3     }},
      {level + 1, {4,     4     }},
      {level,     {x,     y + 1 }},
      {level,     {x,     y - 1 }}
    ]
  end

  @doc """
      iex> Aoc.Day24.neighbours({2, 2})
      [{3, 2}, {1, 2}, {2, 3}, {2, 1}]
  """
  def neighbours({x, y}) do
    [{x + 1, y}, {x - 1, y}, {x, y + 1}, {x, y - 1}]
  end

  def do_mapify([], _, map), do: map
  def do_mapify([?# | t], {x, y}, map), do: do_mapify(t, {x + 1, y}, Map.put(map, {x, y}, :bug))
  def do_mapify([?. | t], {x, y}, map), do: do_mapify(t, {x + 1, y}, Map.put(map, {x, y}, :space))
  def do_mapify([?\n | t], {_, y}, map), do: do_mapify(t, {0, y + 1}, map)

  def input(filename) do
    filename
    |> File.read!()
    |> String.to_charlist()
  end
end
