defmodule Aoc.Day3 do
  @doc """
      iex> "priv/day3/example.txt"  |> Aoc.Day3.part1()
      4361
  """
  def part1(filename) do
    map =
      filename
      |> Aoc.Day3.input()

    syms =
      map
      |> Enum.filter(fn {_, v} ->
        Integer.parse(v) == :error
      end)
      |> Enum.flat_map(fn {pos, _} ->
        neighbours(pos)
      end)

    touchys =
      map
      |> Enum.filter(fn {pos, _} ->
        Enum.member?(syms, pos)
      end)
      |> pmap(fn {pos, _} ->
        pos
      end)

    valid =
      map
      |> Enum.reduce([], fn {pos, v}, acc ->
        if Enum.member?(touchys, pos) do
          Enum.concat(acc, walk(pos, map, acc) |> Enum.uniq())
        else
          acc
        end
      end)

    map
    |> Enum.filter(fn {pos, v} ->
      Enum.member?(valid, pos)
    end)
    |> Enum.into(%{})
    |> print
    |> pmap(fn line ->
      Regex.scan(~r/(\d+)/, line, capture: :all)
    end)
    |> Enum.filter(fn x -> x != [] end)
    |> Enum.map(fn l1 ->
      Enum.map(l1, fn l2 ->
        Enum.at(l2, 0)
      end)
    end)
    |> List.flatten()
    |> pmap(&String.to_integer/1)
    |> Enum.sum()
  end

  def walk({x, y}, map, acc) do
    acc =
      Stream.iterate(0, &(&1 + 1))
      |> Enum.reduce_while(acc, fn i, accc ->
        if Map.get(map, {x + i, y}) != nil and Integer.parse(Map.get(map, {x + i, y})) != :error do
          {:cont, [{x + i, y} | accc]}
        else
          {:halt, accc}
        end
      end)

    acc =
      Stream.iterate(0, &(&1 + 1))
      |> Enum.reduce_while(acc, fn i, accc ->
        if Map.get(map, {x - i, y}) != nil and Integer.parse(Map.get(map, {x - i, y})) != :error do
          {:cont, [{x - i, y} | accc]}
        else
          {:halt, accc}
        end
      end)

    acc
  end

  def pmap(collection, func) do
    collection
    |> Enum.map(&Task.async(fn -> func.(&1) end))
    |> Enum.map(&Task.await/1)
  end

  def size(map) do
    map
    |> Map.keys()
    |> Enum.reduce({0, 0}, fn {x, y}, {maxX, maxY} ->
      {max(x, maxX), max(y, maxY)}
    end)
    |> Tuple.to_list()
    |> Enum.map(&(&1 + 1))
    |> List.to_tuple()
  end

  def print(map) do
    size = size(map)

    Enum.map(0..elem(size, 1), fn y ->
      Enum.map(0..elem(size, 0), fn x ->
        Map.get(map, {x, y}, ".")
      end)
      |> Enum.join("")
      |> IO.inspect()
    end)
  end

  def lins({x, y}) do
    [{x + 1, y}, {x - 1, y}]
    |> Enum.filter(fn {x, y} ->
      x > -1 and y > -1
    end)
  end

  # @doc """
  #     iex> "priv/day3/example.txt" |> Aoc.Day3.input() |> Aoc.Day3.part2()
  #     2286
  # """
  # def part2(list) do
  #   list
  # end

  def neighbours({x, y}) do
    [
      {x + 1, y},
      {x, y + 1},
      {x - 1, y},
      {x, y - 1},
      {x + 1, y + 1},
      {x - 1, y - 1},
      {x + 1, y - 1},
      {x - 1, y + 1}
    ]
    |> Enum.filter(fn {x, y} ->
      x > -1 and y > -1
    end)
  end

  def lines(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split("", trim: true)
    end)
    |> Enum.with_index()
    |> Enum.reduce(Map.new(), fn {line, y}, acc ->
      line
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {cell, x}, aacc ->
        # v =
        #   case Integer.parse(cell) do
        #     :error -> cell
        #     {val, _} -> val
        #   end

        if cell == "." do
          aacc
        else
          Map.put(aacc, {x, y}, cell)
        end
      end)
    end)
  end
end
