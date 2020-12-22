defmodule Aoc.Day21 do
  @doc """
      iex> inp = Aoc.Day21.input("priv/day21/example.txt")
      ...> Aoc.Day21.part1(inp)
      5
  """
  def part1(inp) do
    food = parse_food(inp)

    ingredients =
      food
      |> Map.keys()
      |> Enum.reduce(fn set, acc ->
        MapSet.union(set, acc)
      end)

    allergens =
      food
      |> Map.values()
      |> Enum.reduce(fn set, acc ->
        MapSet.union(set, acc)
      end)

    safe = non_allergic(food, ingredients, allergens)

    food
    |> Map.keys()
    |> Enum.reduce(0, fn recipe, acc ->
      acc + (MapSet.intersection(recipe, safe) |> Enum.count())
    end)
  end

  def non_allergic(food, ingredients, allergens) do
    safe =
      allergens
      |> Enum.flat_map(fn allergen ->
        food
        |> Enum.filter(fn {_ins, algs} ->
          Enum.member?(algs, allergen)
        end)
        |> Enum.map(fn {ins, _algs} ->
          ins
        end)
        |> Enum.reduce(fn ing, acc ->
          MapSet.intersection(ing, acc)
        end)
      end)
      |> MapSet.new()

    MapSet.difference(ingredients, safe)
  end

  def parse_food(inp) do
    inp
    |> Enum.map(fn line ->
      [ings | algs] = String.split(line, "(contains ", trim: true)

      aa =
        algs
        |> Enum.at(0)
        |> String.split(")", trim: true)
        |> Enum.at(0)
        |> String.split(", ")

      {
        ings |> String.split(" ", trim: true) |> MapSet.new(),
        MapSet.new(aa)
      }
    end)
    |> Enum.into(%{})
  end

  def grouped(inp) do
    food = parse_food(inp)

    ingredients =
      food
      |> Map.keys()
      |> Enum.reduce(fn set, acc ->
        MapSet.union(set, acc)
      end)

    allergens =
      food
      |> Map.values()
      |> Enum.reduce(fn set, acc ->
        MapSet.union(set, acc)
      end)

    safe = non_allergic(food, ingredients, allergens)

    allergens
    |> Enum.map(fn allergen ->
      res =
        food
        |> Enum.filter(fn {_k, v} ->
          Enum.member?(v, allergen)
        end)
        |> Enum.map(fn {k, _v} ->
          MapSet.difference(k, safe)
        end)
        |> Enum.reduce(fn x, acc ->
          MapSet.intersection(x, acc)
        end)

      {allergen, res}
    end)
    |> Enum.into(%{})
  end

  @doc """
      iex> inp = Aoc.Day21.input("priv/day21/example.txt")
      ...> Aoc.Day21.part2(inp)
      "mxmxvkd,sqjhc,fvjkl"
  """
  def part2(inp) do
    ings_by = grouped(inp)

    [1, 2, 3]
    |> Stream.cycle()
    |> Enum.reduce_while({%{}, ings_by}, fn _, {found, ings} ->
      if Enum.count(ings) == 0 do
        {:halt, found}
      else
        singles =
          ings
          |> Enum.filter(fn {_k, v} ->
            Enum.count(v) == 1
          end)
          |> Enum.map(fn {k, v} ->
            {k, Enum.at(v, 0)}
          end)
          |> Enum.into(%{})

        ings =
          singles
          |> Map.keys()
          |> Enum.reduce(ings, fn x, acc ->
            Map.delete(acc, x)
          end)

        ings =
          ings
          |> Enum.reduce(%{}, fn {k, v}, acc ->
            Map.put(acc, k, MapSet.difference(v, MapSet.new(Map.values(singles))))
          end)

        {:cont, {Map.merge(found, singles), ings}}
      end
    end)
    |> Enum.sort_by(fn {k, _v} ->
      k
    end)
    |> Enum.map(fn {_k, v} ->
      v
    end)
    |> Enum.join(",")
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
