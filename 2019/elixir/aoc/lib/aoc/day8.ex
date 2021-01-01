defmodule Aoc.Day8 do
  use Memoize

  import Drawille.Canvas

  # @doc """
  #     iex> Aoc.Day8.part1("priv/day8/input.txt")
  #     1584
  # """
  def part1(filename) do
    {layer, _} =
      input(filename, {25, 6})
      |> Enum.map(fn layer ->
        zs =
          layer
          |> List.flatten
          |> Enum.filter(fn x ->
            x == 0
          end)
          |> Enum.count

        {layer, zs}
      end)
      |> Enum.sort_by(fn {_, zc} ->
        zc
      end)
      |> List.first

    nod = layer |> List.flatten |> Enum.filter(fn x -> x == 1 end) |> Enum.count |> IO.inspect
    ntd = layer |> List.flatten |> Enum.filter(fn x -> x == 2 end) |> Enum.count |> IO.inspect

    nod * ntd
  end

  @doc """
      iex> Aoc.Day8.part2("priv/day8/example_2.txt", {2, 2})
      :ok
  """
  def part2(filename, {w, h}) do
    IO.puts("\n")

    do_part2(filename, {w, h})
    |> Enum.with_index
    |> Enum.reduce(new(), fn({row, y}, acc_canvas) ->
      row
      |> Enum.with_index
      |> Enum.reduce(acc_canvas, fn({col, x}, acc_canvas) ->
        if col == 1 do
          set(acc_canvas, x + 1, y + 1)
        else
          unset(acc_canvas, x + 1, y + 1)
        end
      end)
    end)
    |> frame
  end

  @doc """
      iex> Aoc.Day8.do_part2("priv/day8/example_2.txt", {2, 2})
      [[0,1], [1,0]]
  """
  def do_part2(filename, {w, h}) do
    layers = input(filename, {w, h})
    lays =
      List.flatten(layers)
      |> Enum.chunk_every(w * h)

    0..(w*h-1)
    |> Enum.map(fn x ->
      lays
      |> Enum.map(fn lay ->
        Enum.at(lay, x)
      end)
    end)
    |> Enum.map(fn x ->
      visible(x)
    end)
    |> Enum.chunk_every(w)
  end

  @doc """
      iex> Aoc.Day8.visible([0, 1, 2, 0])
      0

      iex> Aoc.Day8.visible([2, 1, 2, 0])
      1

      iex> Aoc.Day8.visible([2, 2, 1, 0])
      1

      iex> Aoc.Day8.visible([2, 2, 2, 0])
      0
  """
  def visible(list) do
    Enum.drop_while(list, fn x -> x == 2 end)
    |> List.first
  end

  defp input(filename, {w, h}) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split("", trim: true)
    |> Enum.map(fn x ->
      String.to_integer(x)
    end)
    |> Enum.chunk_every(w)
    |> Enum.chunk_every(h)
  end
end
