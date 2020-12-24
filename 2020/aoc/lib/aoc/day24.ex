defmodule Aoc.Day24 do
  import ExProf.Macro
  @stretch 1

  @doc """
      iex> inp = Aoc.Day24.input("priv/day24/example3.txt")
      ...> Aoc.Day24.part1(inp)
      10
  """
  def part1(inp) do
    inp
    |> prep()
    |> Enum.reduce(%{}, fn point, acc ->
      Map.update(acc, point, :black, fn wx ->
        case wx do
          :white -> :black
          :black -> :white
        end
      end)
    end)
    |> Map.values()
    |> Enum.count(fn item -> item == :black end)
  end

  def move(dir, %{x: x, y: y, z: z}) do
    case dir do
      "e" ->
        %Aoc.Point{x: x + 1, y: y - 1, z: z}

      "se" ->
        %Aoc.Point{x: x, y: y - 1, z: z + 1}

      "sw" ->
        %Aoc.Point{x: x - 1, y: y, z: z + 1}

      "w" ->
        %Aoc.Point{x: x - 1, y: y + 1, z: z}

      "nw" ->
        %Aoc.Point{x: x, y: y + 1, z: z - 1}

      "ne" ->
        %Aoc.Point{x: x + 1, y: y, z: z - 1}
    end
  end

  def parse_directions(<<>>, acc) do
    Enum.reverse(acc)
  end

  def parse_directions(<<"e", rest::binary>>, acc) do
    parse_directions(rest, ["e" | acc])
  end

  def parse_directions(<<"se", rest::binary>>, acc) do
    parse_directions(rest, ["se" | acc])
  end

  def parse_directions(<<"sw", rest::binary>>, acc) do
    parse_directions(rest, ["sw" | acc])
  end

  def parse_directions(<<"w", rest::binary>>, acc) do
    parse_directions(rest, ["w" | acc])
  end

  def parse_directions(<<"nw", rest::binary>>, acc) do
    parse_directions(rest, ["nw" | acc])
  end

  def parse_directions(<<"ne", rest::binary>>, acc) do
    parse_directions(rest, ["ne" | acc])
  end

#  @doc """
#      iex> inp = Aoc.Day24.input("priv/day24/example3.txt")
#      ...> Aoc.Day24.part2(inp)
#      2208
#  """
  def part2(inp) do
    inp
    |> prep()
    |> make_map()
    |> play(1)
    |> Map.values()
    |> Enum.count(fn item -> item == :black end)
  end

  def prep(inp) do
    inp
    |> Enum.map(fn line ->
      parse_directions(line, [])
      |> Enum.reduce(%Aoc.Point{}, fn dir, point ->
        move(dir, point)
      end)
    end)
  end

  def make_map(points) do
    points
    |> Enum.reduce(%{}, fn point, acc ->
      Map.update(acc, point, :black, fn wx ->
        case wx do
          :white -> :black
          :black -> :white
        end
      end)
    end)
  end

  def resize(map) do
    xs =
      Enum.map(map, fn {%{x: x, y: _y, z: _z}, _val} ->
        x
      end)

    minx = Enum.min(xs)
    maxx = Enum.max(xs)

    ys =
      Enum.map(map, fn {%{x: _x, y: y, z: _z}, _val} ->
        y
      end)

    miny = Enum.min(ys)
    maxy = Enum.max(ys)

    zs =
      Enum.map(map, fn {%{x: _x, y: _y, z: z}, _val} ->
        z
      end)

    minz = Enum.min(zs)
    maxz = Enum.max(zs)

    sides =
      for x <- (minx - @stretch)..(maxx + @stretch),
          y <- (miny - @stretch)..(maxy + @stretch),
          z <- (minz - @stretch)..(maxz + @stretch),
          do: {%Aoc.Point{x: x, y: y, z: z}, Map.get(map, %Aoc.Point{x: x, y: y, z: z}, :white)}

    sides
    |> Enum.into(%{})
    |> Map.merge(map)
  end

  @doc """
      iex> inp = Aoc.Day24.input("priv/day24/example3.txt")
      ...> pre = Aoc.Day24.prep(inp)
      ...> map = Aoc.Day24.make_map(pre)
      ...> res = Aoc.Day24.play(map, 1, 1)
      ...> res |> Map.values |> Enum.count(fn item -> item == :black end)
      15

#      iex> inp = Aoc.Day24.input("priv/day24/example3.txt")
#      ...> pre = Aoc.Day24.prep(inp)
#      ...> map = Aoc.Day24.make_map(pre)
#      ...> res = Aoc.Day24.play(map, 1, 2)
#      ...> res |> Map.values |> Enum.count(fn item -> item == :black end)
#      12
#
#      iex> inp = Aoc.Day24.input("priv/day24/example3.txt")
#      ...> pre = Aoc.Day24.prep(inp)
#      ...> map = Aoc.Day24.make_map(pre)
#      ...> res = Aoc.Day24.play(map, 1, 3)
#      ...> res |> Map.values |> Enum.count(fn item -> item == :black end)
#      25
#
#      iex> inp = Aoc.Day24.input("priv/day24/example3.txt")
#      ...> pre = Aoc.Day24.prep(inp)
#      ...> map = Aoc.Day24.make_map(pre)
#      ...> res = Aoc.Day24.play(map, 1, 10)
#      ...> res |> Map.values |> Enum.count(fn item -> item == :black end)
#      37
#
#      iex> inp = Aoc.Day24.input("priv/day24/example3.txt")
#      ...> pre = Aoc.Day24.prep(inp)
#      ...> map = Aoc.Day24.make_map(pre)
#      ...> res = Aoc.Day24.play(map, 1, 40)
#      ...> res |> Map.values |> Enum.count(fn item -> item == :black end)
#      406
#
#      iex> inp = Aoc.Day24.input("priv/day24/example3.txt")
#      ...> pre = Aoc.Day24.prep(inp)
#      ...> map = Aoc.Day24.make_map(pre)
#      ...> res = Aoc.Day24.play(map, 1, 90)
#      ...> res |> Map.values |> Enum.count(fn item -> item == :black end)
#      1844
#
#      iex> inp = Aoc.Day24.input("priv/day24/example3.txt")
#      ...> pre = Aoc.Day24.prep(inp)
#      ...> map = Aoc.Day24.make_map(pre)
#      ...> res = Aoc.Day24.play(map, 1, 100)
#      ...> res |> Map.values |> Enum.count(fn item -> item == :black end)
#      2208
  """
  def play(map, day, max \\ 100) do
    profile do
      if day > max do
        map
      else
        map = resize(map)

        map
        |> Enum.reduce(%{}, fn {point, val}, acc ->
          ns = neighbours(point)

          black_ns =
            ns
            |> Enum.map(fn n ->
              Map.get(map, n, :white)
            end)
            |> Enum.count(fn x ->
              x == :black
            end)

          cond do
            val == :black && (black_ns == 0 || black_ns > 2) ->
              Map.put(acc, point, :white)

            val == :white && black_ns == 2 ->
              Map.put(acc, point, :black)

            true ->
              Map.put(acc, point, val)
          end
        end)
        |> play(day + 1, max)
      end
      end
  end

  def neighbours(%Aoc.Point{x: x, y: y, z: z}) do
    [
      %Aoc.Point{x: x + 1, y: y - 1, z: z},
      %Aoc.Point{x: x, y: y - 1, z: z + 1},
      %Aoc.Point{x: x - 1, y: y, z: z + 1},
      %Aoc.Point{x: x - 1, y: y + 1, z: z},
      %Aoc.Point{x: x, y: y + 1, z: z - 1},
      %Aoc.Point{x: x + 1, y: y, z: z - 1}
    ]
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
