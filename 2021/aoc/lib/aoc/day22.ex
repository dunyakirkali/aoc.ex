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
    |> Enum.map(fn {com, {x, y, z}} ->
      {com, cubes(x, y, z)}
    end)
    |> IO.inspect(label: "A")
    |> Enum.reduce(MapSet.new, fn step, acc ->
      case step do
        {:on, cubes} ->
          Enum.reduce(cubes, acc, fn point, acc ->
            MapSet.put(acc, point)
          end)
        {:off, cubes} ->
          Enum.reduce(cubes, acc, fn point, acc ->
            MapSet.delete(acc, point)
          end)
      end
    end)
    |> Enum.count()
  end

  def cubes(x, y, z) do
    if Range.disjoint?(-50..50, x) or Range.disjoint?(-50..50, y) or Range.disjoint?(-50..50, x) do
      []
    else
      (for a <- x, b <- y, c <- z, do: {a, b, c})
    end
  end

  def cubes2(x, y, z) do
    (for a <- x, b <- y, c <- z, do: {a, b, c})
  end

  @doc """
      # iex> input = Aoc.Day22.input("priv/day22/example3.txt")
      # ...> Aoc.Day22.part2(input)
      # 2758514936282235
  """
  def part2(input) do
    input
    |> Enum.reduce(MapSet.new, fn step, acc ->
      case step do
        {:on, {x, y, z}} ->
          Enum.reduce(cubes2(x, y, z), acc, fn point, acc ->
            MapSet.put(acc, point)
          end)
        {:off, {x, y, z}} ->
          Enum.reduce(cubes2(x, y, z), acc, fn point, acc ->
            MapSet.delete(acc, point)
          end)
      end
    end)
    |> Enum.count()
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      case line do
        <<"on ", rest::binary>> ->
          [<<"x=", x::binary>>, <<"y=", y::binary>>, <<"z=", z::binary>>] = String.split(rest, ",", trim: true)
          {x, _} = Code.eval_string(x)
          {y, _} = Code.eval_string(y)
          {z, _} = Code.eval_string(z)
          {:on, {x,y,z}}
        <<"off ", rest::binary>> ->
          [<<"x=", x::binary>>, <<"y=", y::binary>>, <<"z=", z::binary>>] = String.split(rest, ",", trim: true)
          {x, _} = Code.eval_string(x)
          {y, _} = Code.eval_string(y)
          {z, _} = Code.eval_string(z)
          {:off, {x,y,z}}
      end
    end)
  end
end
