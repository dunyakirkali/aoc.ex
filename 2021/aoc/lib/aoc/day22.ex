defmodule Aoc.Day22 do
  @doc """
      iex> input = Aoc.Day22.input("priv/day22/example.txt")
      ...> Aoc.Day22.part1(input)
      39

      iex> input = Aoc.Day22.input("priv/day22/example2.txt")
      ...> Aoc.Day22.part1(input)
      590784
  """
  def part1(input) do
    input
    |> filter()
    |> slice_n_dice([])
    |> count()
  end

  def count(cubes) do
    cubes
    |> Enum.reduce(0, fn cube, acc ->
      {ux, vx, uy, vy, uz, vz} = cube
      acc + (vx - ux + 1) * (vy - uy + 1) * (vz - uz + 1)
    end)
  end

  def filter(cubes) do
    cubes
    |> Enum.filter(fn {_, {ux, vx, uy, vy, uz, vz}} ->
      ux < 50 and vx > -50 and uy < 50 and vy > -50 and uz < 50 and vz > -50
    end)
  end

  def slice_n_dice([], cubes), do: cubes

  def slice_n_dice([h | t], cubes) do
    {op, {ux, vx, uy, vy, uz, vz}} = h

    cubes =
      Enum.reduce(cubes, cubes, fn cube, acc ->
        {ux2, vx2, uy2, vy2, uz2, vz2} = cube

        if ux > vx2 or vx < ux2 or uy > vy2 or vy < uy2 or uz > vz2 or vz < uz2 do
          acc
        else
          [
            {ux > ux2, {ux2, ux - 1, uy2, vy2, uz2, vz2}},
            {vx < vx2, {vx + 1, vx2, uy2, vy2, uz2, vz2}},
            {uy > uy2, {max(ux2, ux), min(vx2, vx), uy2, uy - 1, uz2, vz2}},
            {vy < vy2, {max(ux2, ux), min(vx2, vx), vy + 1, vy2, uz2, vz2}},
            {uz > uz2, {max(ux2, ux), min(vx2, vx), max(uy2, uy), min(vy2, vy), uz2, uz - 1}},
            {vz < vz2, {max(ux2, ux), min(vx2, vx), max(uy2, uy), min(vy2, vy), vz + 1, vz2}}
          ]
          |> Enum.reduce(List.delete(acc, cube), fn {k, v}, acc ->
            if k do
              [v | acc]
            else
              acc
            end
          end)
        end
      end)

    cubes =
      if op == :on do
        [{min(ux, vx), max(ux, vx), min(uy, vy), max(uy, vy), min(uz, vz), max(uz, vz)} | cubes]
      else
        cubes
      end

    slice_n_dice(t, cubes)
  end

  @doc """
      iex> input = Aoc.Day22.input("priv/day22/example3.txt")
      ...> Aoc.Day22.part2(input)
      2758514936282235
  """
  def part2(input) do
    input
    |> slice_n_dice([])
    |> count()
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      case line do
        <<"on ", rest::binary>> ->
          [<<"x=", x::binary>>, <<"y=", y::binary>>, <<"z=", z::binary>>] =
            String.split(rest, ",", trim: true)

          [minx, maxx] = String.split(x, "..") |> Enum.map(&String.to_integer/1)
          [miny, maxy] = String.split(y, "..") |> Enum.map(&String.to_integer/1)
          [minz, maxz] = String.split(z, "..") |> Enum.map(&String.to_integer/1)
          {:on, {minx, maxx, miny, maxy, minz, maxz}}

        <<"off ", rest::binary>> ->
          [<<"x=", x::binary>>, <<"y=", y::binary>>, <<"z=", z::binary>>] =
            String.split(rest, ",", trim: true)

          [minx, maxx] = String.split(x, "..") |> Enum.map(&String.to_integer/1)
          [miny, maxy] = String.split(y, "..") |> Enum.map(&String.to_integer/1)
          [minz, maxz] = String.split(z, "..") |> Enum.map(&String.to_integer/1)
          {:off, {minx, maxx, miny, maxy, minz, maxz}}
      end
    end)
  end
end
