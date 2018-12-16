defmodule Day15 do
  use Vivid
  use Memoize

  @moduledoc """
  Documentation for Day15.
  """

  @doc """
  Executes a Round
  """
  def round(map) do
    {map, iteration} =
      0..100_000_000
      |> Enum.reduce_while({map, 0}, fn _, {map, iteration} ->
    
        iteration = iteration + 1
        IO.puts("Iteration: #{iteration}")
    
        map =
          0..(elem(size(map), 1) - 1)
          |> Enum.reduce(map, fn y, map ->
            0..(elem(size(map), 0) - 1)
            |> Enum.reduce(map, fn x, map ->
              pos = {x, y}
              char = map[pos]
      
              case char do
                {"E", _} -> map |> move(pos) |> attack(pos)
                {"G", _} -> map |> move(pos) |> attack(pos)
                _ -> map
              end
            end)
          end)
          |> remove_dead()
    
        if elf_count(map) == 0 or goblin_count(map) == 0 do
          {:halt, {map, iteration}}
        else
          {:cont, {map, iteration}}
        end
      end)
    
    score(map, iteration)
    # |> IO.inspect
  end

  def move(map, pos) do
    if target(map, pos) do
      map
    else
      enemies(map, pos)
      |> IO.inspect(label: "e")
      |> Enum.flat_map(fn {{x, y}, {char, hp}} ->
        neighbours({x, y}, size(map))
      end)
      |> Enum.uniq
      |> Enum.filter(fn {x, y} ->
        reachable(map, pos, {x, y})
      end)
      |> IO.inspect
      # # TODO
      map
    end
  end
  
  def reachable(map, from, to) do
    true
  end
  
  @doc """
      iex> Day15.enemies(%{{0, 0} => {"E", 200}, {1, 0} => ".", {0, 1} => {"G", 10}, {1, 1} => "."}, {0, 0})
      %{{0, 1} => {"G", 10}}
  """
  def enemies(map, pos) do
    case map[pos] do
      {"E", _} ->
        Enum.filter(map, fn {{x, y}, char} ->
          if is_tuple(char) do
            elem(char, 0) == "G"
          else
            false
          end
        end) |> Enum.into(%{})
      {"G", _} ->
        Enum.filter(map, fn {{x, y}, char} ->
          if is_tuple(char) do
            elem(char, 0) == "E"
          else
            false
          end
        end) |> Enum.into(%{})
    end
  end

  @doc """
      iex> Day15.remove_dead(%{{0, 0} => {"E", 200}, {1, 0} => ".", {0, 1} => {"G", 0}, {1, 1} => "."})
      %{{0, 0} => {"E", 200}, {1, 0} => ".", {0, 1} => ".", {1, 1} => "."}
  """
  def remove_dead(map) do
    map
    |> Enum.map(fn {pos, data} ->
      if is_tuple(data) do
        if elem(data, 1) <= 0 do
          {pos, "."}
        else
          {pos, data}
        end
      else
        {pos, data}
      end
    end)
    |> Enum.into(%{})
  end
  
  @doc """
      iex> Day15.goblin_count(%{{0, 0} => {"E", 200}, {1, 0} => ".", {0, 1} => {"G", 200}, {1, 1} => "."})
      1
  """
  def goblin_count(map) do
    length(Enum.filter(map, fn {_, char} ->
      if is_tuple(char) do
        elem(char, 0) == "G"
      else
        false
      end
    end))
  end
  
  @doc """
      iex> Day15.elf_count(%{{0, 0} => {"E", 200}, {1, 0} => ".", {0, 1} => {"G", 200}, {1, 1} => "."})
      1
  """
  def elf_count(map) do
    length(Enum.filter(map, fn {_, char} ->
      if is_tuple(char) do
        elem(char, 0) == "E"
      else
        false
      end
    end))
  end
  
  @doc """
      iex> Day15.attack(%{{0, 0} => {"E", 200}, {1, 0} => ".", {0, 1} => {"G", 200}, {1, 1} => "."}, {0, 0})
      %{{0, 0} => {"E", 200}, {1, 0} => ".", {0, 1} => {"G", 197}, {1, 1} => "."}
  """
  def attack(map, pos) do
    target = target(map, pos)
    if target do
      Map.update!(map, target, fn {char, hp} ->
        {char, hp - 3}
      end)
    else
      map
    end
  end
  
  @doc """
      iex> Day15.target(%{{0, 0} => {"E", 200}, {1, 0} => ".", {0, 1} => {"G", 200}, {1, 1} => "."}, {0, 0})
      {0, 1}
      
      iex> Day15.target(%{{0, 0} => {"E", 200}, {1, 0} => ".", {0, 1} => ".", {1, 1} => "."}, {0, 0})
      nil
  """
  def target(map, pos) do
    target = 
      neighbours(pos, size(map))
      |> Enum.map(fn pos ->
        {pos, map[pos]}
      end)
      |> Enum.filter(fn {_, char} ->
        if is_tuple(char) do
          case map[pos] do
            {"E", _} -> elem(char, 0) == "G"
            {"G", _} -> elem(char, 0) == "E"
          end
        else
          false
        end
      end)
      |> List.first
    
    if target do
      elem(target, 0)
    else
      nil
    end
  end
  
  @doc """
      iex> Day15.score(%{{0, 0} => {"E", 200}, {1, 0} => ".", {0, 1} => {"G", 200}, {1, 1} => "."}, 2)
      800
  """
  def score(map, iterations) do
    iterations * sum_of_all_hp(map)
  end
  
  @doc """
      iex> Day15.sum_of_all_hp(%{{0, 0} => {"E", 200}, {1, 0} => ".", {0, 1} => {"G", 200}, {1, 1} => "."})
      400
      
      iex> Day15.sum_of_all_hp(%{{0, 0} => {"E", 200}, {1, 0} => ".", {0, 1} => ".", {1, 1} => "."})
      200
  """
  def sum_of_all_hp(map) do
    map
    |> Enum.map(fn {_, data} ->
      if is_tuple(data) do
        elem(data, 1)
      else
        0
      end
    end)
    |> Enum.sum
  end
  
  @doc """
      iex> Day15.neighbours({1, 1}, {3, 3})
      [{1, 0}, {0, 1}, {2, 1}, {1, 2}]
  """
  def neighbours(cell, size) do
    cellX = elem(cell, 0)
    cellY = elem(cell, 1)
    cell
    |> all_neighbours(size)
    |> Enum.filter(fn {x, y} ->
      cellX == x || cellY == y
    end)
    |> Enum.filter(fn {x, y} ->
      cellX != x || cellY != y
    end)
  end
  
  @doc """
      iex> Day15.size(%{{0, 0} => "."})
      {1, 1}
  
      iex> Day15.size(%{{0, 0} => ".", {1, 0} => ".", {0, 1} => ".", {1, 1} => "."})
      {2, 2}
  """
  defmemo size(map) do
    keys = Map.keys(map)
    xs = Enum.map(keys, fn {x, _} ->
      x
    end)
    ys = Enum.map(keys, fn {_, y} ->
      y
    end)
    {Enum.max(xs) + 1, Enum.max(ys) + 1}
  end
  
  @doc """
      iex> Day15.all_neighbours({1, 1}, {3, 3})
      [{0, 0}, {1, 0}, {2, 0}, {0, 1}, {1, 1}, {2, 1}, {0, 2}, {1, 2}, {2, 2}]
      
      iex> Day15.all_neighbours({0, 0}, {2, 2})
      [{0, 0}, {1, 0}, {0, 1}, {1, 1}]
      
      iex> Day15.all_neighbours({1, 1}, {2, 2})
      [{0, 0}, {1, 0}, {0, 1}, {1, 1}]
  """
  def all_neighbours(cell, size) do
    cellX = elem(cell, 0)
    cellY = elem(cell, 1)
    minX = max(0, cellX - 1)
    minY = max(0, cellY - 1)
    maxX = min(elem(size, 0) - 1, cellX + 1)
    maxY = min(elem(size, 1) - 1, cellY + 1)
    for y <- Enum.to_list(minY..maxY),
        x <- Enum.to_list(minX..maxX),
        do: {x, y}
  end
  
  @doc """
  Parses the input into a Map
  """
  defmemo parse_map(filename) do
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
        if Enum.member?(["E", "G"], char) do
          Map.put(acc, {x, y}, {char, 200})
        else
          Map.put(acc, {x, y}, char)
        end
      end)
    end)
  end
end
