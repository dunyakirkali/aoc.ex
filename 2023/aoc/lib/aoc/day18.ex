defmodule Aoc.Day18 do
  @doc """
      iex> "priv/day18/example.txt" |> Aoc.Day18.input() |> Aoc.Day18.part1()
      62
  """
  def part1(map) do
    {b, points} = to_map(map, false)

    a =
      Range.new(0, Enum.count(points) - 1)
      |> Enum.map(fn i ->
        {xi, _} = Enum.at(points, i)
        {_, yib} = Enum.at(points, i - 1)
        {_, yia} = Enum.at(points, rem(i + 1, Enum.count(points)))

        xi * (yib - yia)
      end)
      |> Enum.sum()
      |> abs
      |> Kernel.div(2)

    i = a - div(b, 2) + 1
    i + b
  end

  @doc """
      iex> "priv/day18/example.txt" |> Aoc.Day18.input() |> Aoc.Day18.part2()
      952408144115
  """
  def part2(map) do
    {b, points} = to_map(map, true)

    a =
      Range.new(0, Enum.count(points) - 1)
      |> Enum.map(fn i ->
        {xi, _} = Enum.at(points, i)
        {_, yib} = Enum.at(points, i - 1)
        {_, yia} = Enum.at(points, rem(i + 1, Enum.count(points)))

        xi * (yib - yia)
      end)
      |> Enum.sum()
      |> abs
      |> Kernel.div(2)

    i = a - div(b, 2) + 1
    i + b
  end

  def to_map(ins, part2) do
    ins
    |> Enum.reduce(
      {0, {0, 0}, [{0, 0}]},
      fn {dir, amnt, pam, pd}, {len, {px, py}, points} ->
        len =
          len +
            case if(part2, do: pd, else: dir) do
              :r ->
                if(part2, do: pam, else: amnt)

              :d ->
                if(part2, do: pam, else: amnt)

              :u ->
                if(part2, do: pam, else: amnt)

              :l ->
                if(part2, do: pam, else: amnt)
            end

        {px, py} =
          case if(part2, do: pd, else: dir) do
            :r -> {px + if(part2, do: pam, else: amnt), py}
            :d -> {px, py + if(part2, do: pam, else: amnt)}
            :u -> {px, py - if(part2, do: pam, else: amnt)}
            :l -> {px - if(part2, do: pam, else: amnt), py}
          end

        {len, {px, py}, [{px, py} | points]}
      end
    )
    |> then(fn {map, _, points} ->
      {map, points}
    end)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [ds, ms, cs] =
        line
        |> String.split(" ", trim: true)

      hex =
        cs
        |> String.slice(2, 6)

      {ncs, _} =
        hex
        |> String.slice(0, 5)
        |> Integer.parse(16)

      dcs =
        case hex |> String.slice(5, 1) do
          "0" -> :r
          "1" -> :d
          "2" -> :l
          "3" -> :u
        end

      {String.downcase(ds) |> String.to_atom(), String.to_integer(ms), ncs, dcs}
    end)
  end
end
