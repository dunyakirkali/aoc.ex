defmodule Aoc.Day15 do
  @doc """
      iex> "priv/day15/example.txt" |> Aoc.Day15.input() |> Aoc.Day15.part1()
      26
  """
  def part1(data) do
    data
    |> IO.inspect()
    |> new()
    |> IO.inspect()
    |> then(fn {beacons, cants} ->
      MapSet.difference(cants, beacons)
      |> Enum.count()
    end)
  end

  def new(list, y \\ 2_000_000) do
    list
    |> Enum.reduce({MapSet.new(), MapSet.new()}, fn {{n0, _} = p1, p2}, {beacons, cants} ->
      beacons = MapSet.put(beacons, p2)
      dist = manhattan(p1, p2)

      cants =
        (n0 - dist)..(n0 + dist + 1)
        |> Enum.to_list()
        |> Enum.reduce(cants, fn x, cants ->
          if manhattan(p1, {x, y}) <= dist do
            MapSet.put(cants, {x, y})
          else
            cants
          end
        end)

      {beacons, cants}
    end)
  end

  def manhattan({ax, ay}, {bx, by}) do
    abs(ax - bx) + abs(ay - by)
  end

  # @doc """
  #     iex> "priv/day15/example.txt" |> Aoc.Day15.input() |> Aoc.Day15.part2()
  #     56000011
  # """
  # def part2(moves) do
  #   moves
  # end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      matches =
        Regex.named_captures(
          ~r/Sensor at x=(?<sx>\d+), y=(?<sy>\d+): closest beacon is at x=(?<bx>-?\d+), y=(?<by>-?\d+)/,
          line
        )

      {
        {
          matches["sx"] |> String.to_integer(),
          matches["sy"] |> String.to_integer()
        },
        {
          matches["bx"] |> String.to_integer(),
          matches["by"] |> String.to_integer()
        }
      }
    end)
  end
end
