defmodule Aoc.Day24 do
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
          :space -> Drawille.Canvas.unset(acc_canvas, x + 1, y + 1)
          :bug -> Drawille.Canvas.set(acc_canvas, x + 1, y + 1)
        end
      acc_canvas
    end)
    |> Drawille.Canvas.frame
    map
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
