defmodule Aoc.Day13 do
  @doc """
      iex> input = Aoc.Day13.input("priv/day13/example.txt")
      ...> Aoc.Day13.part1(input)
      17
  """
  def part1({graph, instructions}) do
    instructions
    |> Enum.take(1)
    |> Enum.reduce(graph, fn [dir, amount], acc ->
      fold(acc, dir, amount)
    end)
    |> Map.values()
    |> Enum.count(fn chr ->
      chr == "#"
    end)
  end

  def print(map) do
    IO.puts("")

    height = Map.keys(map) |> Enum.map(fn {x, _} -> x end) |> Enum.max
    width = Map.keys(map) |> Enum.map(fn {_, y} -> y end) |> Enum.max
    Enum.map(0..width, fn row ->
      Enum.map(0..height, fn col ->
        pos = {col, row}
        value = Map.get(map, pos, ".")
        IO.ANSI.format([:green, to_string(value), :reset])
      end)
      |> Enum.intersperse("")
    end)
    |> Enum.join("\n")
    |> IO.puts()

    map
  end

  defp fold(graph, dir, amount) do
    Enum.reduce(graph, %{}, fn {{x, y}, val}, acc ->
      case dir do
        "x" ->
          if x > amount do
            Map.put(acc, {2*amount - x, y}, val)
          else
            Map.put(acc, {x, y}, val)
          end
        "y" ->
          if y > amount do
            Map.put(acc, {x, 2*amount-y}, val)
          else
            Map.put(acc, {x, y}, val)
          end
      end
    end)
  end

  @doc """
      iex> input = Aoc.Day13.input("priv/day13/example.txt")
      ...> Aoc.Day13.part2(input)
      :ok
  """
  def part2({graph, instructions}) do
    instructions
    |> Enum.reduce(graph, fn [dir, amount], acc ->
      fold(acc, dir, amount)
    end)
    |> print()

    :ok
  end

  def input(filename) do
    [dots, instructions] =
      filename
      |> File.read!()
      |> String.split("\n\n", trim: true)

    graph =
      dots
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        line
        |> String.split(",", trim: true)
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.reduce(%{}, fn point, acc ->
        Map.put(acc, List.to_tuple(point), "#")
      end)

    instructions
      = instructions
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        ["fold", "along", instruction] = String.split(line, " ", trim: true)

        [dir, amount] =
          instruction
          |> String.split("=", trim: true)

        [dir, String.to_integer(amount)]
      end)

    {graph, instructions}
  end
end
