defmodule Aoc.Day17 do
  def part2() do
    [
      'L', '4', 'L', '4', 'L', '6', 'R', '10', 'L', '6',
      'L', '4', 'L', '4', 'L', '6', 'R', '10', 'L', '6',

      'L', '12', 'L', '6', 'R', '10', 'L', '6',

      'R', '8', 'R', '10', 'L', '6',
      'R', '8', 'R', '10', 'L', '6',

      'L', '4', 'L', '4', 'L', '6', 'R', '10', 'L', '6',

      'R', '8', 'R', '10', 'L', '6',

      'L', '12', 'L', '6', 'R', '10', 'L', '6',

      'R', '8', 'R', '10', 'L', '6',

      'L', '12', 'L', '6', 'R', '10', 'L', '6'
    ]

    program =
      "A,A,B,C,C,A,C,B,C,B\nL,4,L,4,L,6,R,10,L,6\nL,12,L,6,R,10,L,6\nR,8,R,10,L,6\nn\n"
      |> String.graphemes
      |> Enum.map(fn x ->
        x
        |> String.to_charlist
        |> hd
      end)

    "priv/day17/input.txt"
    |> AGC.new()
    |> AGC.reset(0)
    |> AGC.run
    |> Map.put(:inputs, program)
    |> AGC.run
    |> Map.get(:output)
    |> List.last
  end

  def part1() do
    "priv/day17/input.txt"
    |> AGC.new()
    |> AGC.run()
    |> Map.get(:output)
    |> Enum.chunk_every(46)
    |> Enum.with_index
    |> Enum.reduce(Map.new, fn {row, y}, map ->
      row
      |> Enum.with_index
      |> Enum.reduce(map, fn {item, x}, map ->
        Map.put(map, {x, y}, <<item::utf8>>)
      end)
    end)
    |> Enum.filter(fn {_, val} ->
      val == "#"
    end)
    |> Map.new
    |> find_intersections
    |> sum_of_alignment_params
  end

  def find_intersections(map) do
    map
    |> Enum.filter(fn {pos, _} ->
      pos
      |> neighbours()
      |> Enum.all?(fn pos ->
        Map.get(map, pos) == "#"
      end)
    end)
  end

  def neighbours({x, y}) do
    [
      {x + 1, y},
      {x - 1, y},
      {x, y + 1},
      {x, y - 1}
    ]
    |> Enum.filter(fn {x, y} ->
      x > -1 and y > -1
    end)
  end

  def sum_of_alignment_params(map) do
    map
    |>  Enum.map(fn {{x, y}, _} ->
      x * y
    end)
    |> Enum.sum
  end
end
