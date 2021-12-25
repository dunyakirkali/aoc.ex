defmodule Aoc.Day25 do
  @doc """
      iex> input = Aoc.Day25.input("priv/day25/example.txt")
      ...> Aoc.Day25.part1(input)
      58
  """
  def part1(input) do
    width = Map.keys(input) |> Enum.map(fn {x, _} -> x end) |> Enum.max()
    height = Map.keys(input) |> Enum.map(fn {_, y} -> y end) |> Enum.max()

    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while(input, fn i, prev ->
      next =
        prev
        |> move_right(width, height)
        |> move_down(width, height)

      if next == prev do
        {:halt, i + 1}
      else
        {:cont, next}
      end
    end)
  end

  def print(map, width, height) do
    IO.puts("")

    Enum.map(0..width, fn row ->
      Enum.map(0..height, fn col ->
        pos = {col, row}
        value = Map.get(map, pos, ".")
        to_string(value)
      end)
      |> Enum.intersperse("")
    end)
    |> Enum.join("\n")
    |> IO.puts()

    map
  end

  def move_down(input, width, height) do
    Enum.reduce(0..width, input, fn x, acc ->
      Enum.reduce(0..height, acc, fn y, acc ->
        case input[{x, y}] do
          "v" ->
            case input[{x, rem(y + 1, height + 1)}] do
              "." ->
                Map.merge(acc, %{
                  {x, y} => ".",
                  {x, rem(y + 1, height + 1)} => "v"
                })

              _ ->
                acc
            end

          _ ->
            acc
        end
      end)
    end)
  end

  def move_right(input, width, height) do
    Enum.reduce(0..width, input, fn x, acc ->
      Enum.reduce(0..height, acc, fn y, acc ->
        case input[{x, y}] do
          ">" ->
            case input[{rem(x + 1, width + 1), y}] do
              "." ->
                Map.merge(acc, %{
                  {x, y} => ".",
                  {rem(x + 1, width + 1), y} => ">"
                })

              _ ->
                acc
            end

          _ ->
            acc
        end
      end)
    end)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {row, y}, acc ->
      row
      |> String.graphemes()
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {char, x}, acc ->
        Map.put(acc, {x, y}, char)
      end)
    end)
  end
end
