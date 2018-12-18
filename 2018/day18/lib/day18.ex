defmodule Day18 do
  use Memoize

  @moduledoc """
  Documentation for Day18.
  """
  
  def part_2(filename, minutes \\ 10) do
    map = forest(filename)
    
    history = %{}
    
    {minute, last_seen, map, history} =
      1..minutes
      |> Enum.reduce_while({0, 0, map, history}, fn minute, {_, _, map, history} ->
        normalized = map |> Enum.map(fn {{x, y}, v} -> {"#{x}-#{y}", v} end) |> Enum.into(%{})
        serialized = Poison.encode!(normalized)
        
        if history[serialized] == nil do
          history = Map.put(history, serialized, minute)
          IO.puts("Minute: #{minute}")
          print_game(map)
          {:cont, {minute, 0, iterate(map), history}}
        else
          IO.puts("Minute: #{minute}, Last seen: #{history[serialized]}")
          {:halt, {minute, history[serialized], iterate(map), history}}
        end
      end)

    offset = 
      history
      |> Map.values
      |> Enum.max
    
    adjusted_minutes = rem((minutes - offset), (minute - last_seen))
    
    part_1(filename, offset + adjusted_minutes)
  end
  
  def part_1(filename, minutes \\ 10) do
    map = forest(filename)
    
    {wood_count, lumberyard_count} =
      1..minutes
      |> Enum.reduce(map, fn minute, map ->
        IO.puts("Minute: #{minute}")
        iterate(map)
      end)
      |> Enum.reduce({0, 0}, fn {{x, y}, val}, {wood_count, lumberyard_count} ->
        case val do
          "|" -> {wood_count + 1, lumberyard_count}
          "#" -> {wood_count, lumberyard_count + 1}
          _   -> {wood_count, lumberyard_count}
        end
      end)
      
    wood_count * lumberyard_count
  end
  
  def iterate(map) do
    {sizeX, sizeY} = size(map)
    
    Enum.reduce(0..sizeY, %{}, fn y, acc ->
      Enum.reduce(0..sizeX, acc, fn x, acc ->
        cell = {x, y}
        neighbours = neighbours(map, cell, {sizeX, sizeY})
        |> Enum.map(fn pos ->
          map[pos]
        end)
        
        Map.put(acc, cell, lookup(map[cell], neighbours))
      end)
    end)
  end
  
  defmemo size(map) do
    {
      Map.keys(map) |> Enum.map(fn x -> elem(x, 0) end) |> Enum.max(),
      Map.keys(map) |> Enum.map(fn x -> elem(x, 1) end) |> Enum.max()
    }
  end

  defmemo lookup(char, list) do
    cond do
      char == "." && Enum.count(Enum.filter(list, fn char -> char == "|" end)) >= 3 ->
        "|"
      char == "|" && Enum.count(Enum.filter(list, fn char -> char == "#" end)) >= 3 ->
        "#"
      char == "#" && Enum.count(Enum.filter(list, fn char -> char == "#" end)) >= 1  && Enum.count(Enum.filter(list, fn char -> char == "|" end)) >= 1 ->
        "#"
      char == "#" && (Enum.count(Enum.filter(list, fn char -> char == "#" end)) < 1  || Enum.count(Enum.filter(list, fn char -> char == "|" end)) < 1) ->
        "."
      true ->
        char
    end
  end

  @doc """
      iex> map = Day18.forest("priv/example.txt")
      ...> Day18.neighbours(map, {1, 1}, {3, 3})
      [
        {0, 0},
        {0, 1},
        {0, 2},
        {1, 0},
        {1, 2},
        {2, 0},
        {2, 1},
        {2, 2}
      ]
  """
  def neighbours(map, cell, size) do
    sizeX = elem(size, 0)
    sizeY = elem(size, 1)

    fromX = max(0, elem(cell, 0) - 1)
    toX = min(sizeX, elem(cell, 0) + 1)

    fromY = max(0, elem(cell, 1) - 1)
    toY = min(sizeY, elem(cell, 1) + 1)

    all =
      for x <- Enum.to_list(fromX..toX),
          y <- Enum.to_list(fromY..toY),
          do: {x, y}

    Enum.filter(all, fn {x, y} -> x != elem(cell, 0) || y != elem(cell, 1) end)
  end

  @doc """
      iex> map = Day18.forest("priv/example.txt")
      ...> map[{0, 0}]
      "."
      ...> map[{1, 2}]
      "|"
  """
  def forest(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(fn row ->
      String.codepoints(row)
    end)
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {col, y}, acc ->
      col
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {char, x}, acc ->
        Map.put(acc, {x, y}, char)
      end)
    end)
  end
  
  defp print_game(map) do
    IEx.Helpers.clear
    xses = Map.keys(map) |> Enum.map(fn x -> elem(x, 0) end)
    maxX = Enum.max(xses)
    minX = Enum.min(xses)
    maxY = Map.keys(map) |> Enum.map(fn x -> elem(x, 1) end) |> Enum.max()

    Enum.each(Range.new(0, maxY), fn y ->
      Enum.map(Range.new(minX, maxX), fn x ->
        p = {x, y}

        cond do
          is_nil(map[p]) -> "."
          true -> map[p]
        end
      end)
      |> Enum.join("")
      |> IO.puts()
    end)
  end
end
