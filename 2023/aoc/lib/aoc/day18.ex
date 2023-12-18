defmodule Aoc.Day18 do
  @doc """
      iex> "priv/day18/example.txt" |> Aoc.Day18.input() |> Aoc.Day18.part1()
      62
  """
  def part1(map) do
    nm = to_map(map, false)

    minx =
      nm
      |> Map.keys()
      |> Enum.map(fn {x, _} -> x end)
      |> Enum.min()

    nm
    |> Enum.map(fn {{px, py}, val} ->
      case val do
        "#" ->
          # {{px, py}, val}
          1

        "." ->
          # if inside(nm, {px, py}), do: {{px, py}, "#"}, else: {{px, py}, "."}
          if inside(nm, {px, py}, minx), do: 1, else: 0
      end
    end)
    # |> Enum.into(%{})
    |> Enum.sum()

    # |> draw()
  end

  def inside(map, {px, py}, minx) do
    for(cx <- minx..px, do: Map.get(map, {cx, py}))
    |> Enum.dedup()
    |> Enum.count(fn v -> v == "#" end)
    |> Kernel.rem(2)
    |> Kernel.==(1)
  end

  def draw(map) do
    IO.puts("\n")

    {minx, maxx} =
      map
      |> Map.keys()
      |> Enum.map(&elem(&1, 0))
      |> Enum.min_max()

    {miny, maxy} =
      map
      |> Map.keys()
      |> Enum.map(&elem(&1, 1))
      |> Enum.min_max()

    Enum.each(miny..maxy, fn y ->
      Enum.map(minx..maxx, fn x ->
        Map.get(map, {x, y}, ".")
      end)
      |> Enum.join("")
      |> IO.puts()
    end)

    IO.puts("\n")
    map
  end

  @doc """
      # iex> "priv/day18/example.txt" |> Aoc.Day18.input() |> Aoc.Day18.part2()
      # 94
  """
  def part2(map) do
    # nm = to_map(map, true)

    # returns {192, ""}
  end

  def to_map(ins, part2) do
    map =
      ins
      |> Enum.reduce({%{}, {10000, 10000}}, fn {dir, amnt, pam}, {map, {px, py}} ->
        map =
          case dir do
            :r ->
              for(dx <- 0..if(part2, do: pam, else: amnt), into: map, do: {{px + dx, py}, "#"})

            :d ->
              for(dy <- 0..if(part2, do: pam, else: amnt), into: map, do: {{px, py + dy}, "#"})

            :u ->
              for(dy <- 0..if(part2, do: pam, else: amnt), into: map, do: {{px, py - dy}, "#"})

            :l ->
              for(dx <- 0..if(part2, do: pam, else: amnt), into: map, do: {{px - dx, py}, "#"})
          end

        {px, py} =
          case dir do
            :r -> {px + if(part2, do: pam, else: amnt), py}
            :d -> {px, py + if(part2, do: pam, else: amnt)}
            :u -> {px, py - if(part2, do: pam, else: amnt)}
            :l -> {px - if(part2, do: pam, else: amnt), py}
          end

        {map, {px, py}}
      end)
      |> elem(0)

    {minx, maxx} =
      map
      |> Map.keys()
      |> Enum.map(&elem(&1, 0))
      |> Enum.min_max()

    {miny, maxy} =
      map
      |> Map.keys()
      |> Enum.map(&elem(&1, 1))
      |> Enum.min_max()

    for cx <- minx..maxx,
        cy <- miny..maxy,
        into: %{},
        do: {{cx, cy}, Map.get(map, {cx, cy}, ".")}
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [ds, ms, cs] =
        line
        |> String.split(" ", trim: true)

      {ncs, _} =
        cs
        |> String.slice(2, 6)
        |> Integer.parse(16)

      {String.downcase(ds) |> String.to_atom(), String.to_integer(ms), ncs}
    end)
  end
end
