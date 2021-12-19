defmodule Aoc.Day19 do
  @doc """
      iex> input = Aoc.Day19.input("priv/day19/example.txt")
      ...> Aoc.Day19.part1(input)
      79
  """
  def part1(input) do
    scanner_positions = %{
      0 => {[0,0,0], 0}
    }
    beacons = Map.get(input, 0)

    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while({beacons, scanner_positions}, fn _i, {bs, sp} ->
      if Enum.count(sp) == Enum.count(input) do
        {:halt, {bs, Map.values(sp)}}
      else

        {bs, sp} =
        input
        |> Map.keys()
        |> Enum.filter(fn ind ->
          not Enum.member?(Map.keys(sp), ind)
        end)
        |> Enum.reduce({bs, sp}, fn index, {bs, sp} ->
          index |> IO.inspect(label: "index")
          scans = Map.get(input, index)
          Enum.reduce(sp, {bs, sp}, fn {i, position}, {bs, sp} ->
            {i, position} |> IO.inspect(label: "acc")
            known_scans = convert(Map.get(input, i), position)
            scanner_position = find_orientation(scans, known_scans)
            if scanner_position != {} do
              {[convert(scans, scanner_position) | bs] , Map.put(sp, index, scanner_position)}
            else
              {bs, sp}
            end
          end)
        end)

        {:cont, {bs, sp}}
      end
    end)
  end

  def find_orientation(scans, known_scans) do
    0..23
    |> Enum.reduce({}, fn i, acc ->
      scans = Enum.map(scans, fn scan ->
        Enum.at(orientations(scan), i)
      end)

      Enum.reduce_while(scans, acc, fn scan, acc ->
        res = Enum.reduce_while(known_scans, acc, fn known_scan, acc ->
          offset = sub(known_scan, scan)

          count = Enum.count(scans, fn scan ->
            Enum.member?(known_scans, add(scan, offset))
          end)

          if count >= 12 do
            {:halt, {:halt, {offset, i}}}
          else
            {:cont, {:cont, {}}}
          end
        end)
      end)
    end)
  end

  @doc """
      # iex> input = Aoc.Day19.input("priv/day19/example.txt")
      # ...> Aoc.Day19.part2(input)
      # nil
  """
  def part2(input) do

  end

  @doc """
      iex> Aoc.Day19.distance([2, 3, 4], [-4, -3, -2])
      18
  """
  def distance([lx, ly, lz], [rx, ry, rz]) do
    abs(lx - rx) + abs(ly - ry) + abs(lz - rz)
  end

  @doc """
      iex> Aoc.Day19.convert([[1, 1, 1], [2, 2, 2]], {[2, 3, 4], 2})
      [[1, 2, 5], [0, 1, 6]]
  """
  def convert(scans, {offset, rotation}) do
    scans
    |> Enum.map(fn scan ->
      scan
      |> orientations()
      |> Enum.at(rotation)
      |> add(offset)
    end)
  end

  @doc """
      iex> Aoc.Day19.add([2, 3, 4], [-4, -3, -2])
      [-2, 0, 2]
  """
  def add([lx, ly, lz], [rx, ry, rz]) do
    [lx + rx, ly + ry, lz + rz]
  end

  @doc """
      iex> Aoc.Day19.sub([2, 3, 4], [-4, -3, -2])
      [6, 6, 6]
  """
  def sub([lx, ly, lz], [rx, ry, rz]) do
    [lx - rx, ly - ry, lz - rz]
  end

  @doc """
      iex> Aoc.Day19.orientations([2, 3, 4])
      [[2, 3, 4], [3, -2, 4], [-2, -3, 4], [-3, 2, 4], [-4, 3, 2], [3, 4, 2], [4, -3, 2], [-3, -4, 2], [-2, 3, -4], [3, 2, -4], [2, -3, -4], [-3, -2, -4], [4, 3, -2], [3, -4, -2], [-4, -3, -2], [-3, 4, -2], [2, 4, -3], [4, -2, -3], [-2, -4, -3], [-4, 2, -3], [2, -4, 3], [-4, -2, 3], [-2, 4, 3], [4, 2, 3]]
  """
  def orientations(pos) do
    [
      pos,
      pos |> rotate(:z),
      pos |> rotate(:z) |> rotate(:z),
      pos |> rotate(:z) |> rotate(:z) |> rotate(:z),

      pos |> rotate(:y),
      pos |> rotate(:y) |> rotate(:z),
      pos |> rotate(:y) |> rotate(:z) |> rotate(:z),
      pos |> rotate(:y) |> rotate(:z) |> rotate(:z) |> rotate(:z),

      pos |> rotate(:y) |> rotate(:y),
      pos |> rotate(:y) |> rotate(:y) |> rotate(:z),
      pos |> rotate(:y) |> rotate(:y) |> rotate(:z) |> rotate(:z),
      pos |> rotate(:y) |> rotate(:y) |> rotate(:z) |> rotate(:z) |> rotate(:z),

      pos |> rotate(:y) |> rotate(:y) |> rotate(:y),
      pos |> rotate(:y) |> rotate(:y) |> rotate(:y) |> rotate(:z),
      pos |> rotate(:y) |> rotate(:y) |> rotate(:y) |> rotate(:z) |> rotate(:z),
      pos |> rotate(:y) |> rotate(:y) |> rotate(:y) |> rotate(:z) |> rotate(:z) |> rotate(:z),

      pos |> rotate(:x),
      pos |> rotate(:x) |> rotate(:z),
      pos |> rotate(:x) |> rotate(:z) |> rotate(:z),
      pos |> rotate(:x) |> rotate(:z) |> rotate(:z) |> rotate(:z),

      pos |> rotate(:x) |> rotate(:x) |> rotate(:x),
      pos |> rotate(:x) |> rotate(:x) |> rotate(:x) |> rotate(:z),
      pos |> rotate(:x) |> rotate(:x) |> rotate(:x) |> rotate(:z) |> rotate(:z),
      pos |> rotate(:x) |> rotate(:x) |> rotate(:x) |> rotate(:z) |> rotate(:z) |> rotate(:z),
    ]
  end

  @doc """
      iex> Aoc.Day19.rotate([2, 3, 4], :x)
      [2, 4, -3]

      iex> Aoc.Day19.rotate([2, 3, 4], :y)
      [-4, 3, 2]

      iex> Aoc.Day19.rotate([2, 3, 4], :z)
      [3, -2, 4]
  """
  def rotate([x, y, z], :x), do: [x, z, -y]
  def rotate([x, y, z], :y), do: [-z, y, x]
  def rotate([x, y, z], :z), do: [y, -x, z]

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn scanner ->
      [h | t] =
        scanner
        |> String.split("\n", trim: true)

      <<"--- scanner ", sno ," ---">> = h
      coords =
        t
        |> Enum.map(fn line ->
          line
          |> String.split(",", trim: true)
          |> Enum.map(fn cor ->
            String.to_integer(cor)
          end)
        end)

      {sno - ?0, coords}
    end)
    |> Enum.into(%{})
  end
end
