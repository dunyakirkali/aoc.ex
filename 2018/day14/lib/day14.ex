defmodule Day14 do
  @moduledoc """
  Documentation for Day14.
  """
  
  @doc """
      iex> Day14.part_1(9)
      "5158916779"
      
      iex> Day14.part_1(5)
      "0124515891"
      
      iex> Day14.part_1(18)
      "9251071085"
      
      iex> Day14.part_1(2018)
      "5941429882"
  """
  def part_1(count) do
    point = 10
    recipes = [3, 7]
    positions = {0, 1}
    0..999_999_999
    |> Enum.reduce_while({recipes, positions}, fn _, {recipes, positions} ->
      {recipes, positions} = iterate({recipes, positions})
      IO.puts("#{length(recipes)} > #{count + point}")
      if length(recipes) >= count + point do
        {:halt, {recipes, positions}}
      else
        {:cont, {recipes, positions}}
      end
    end)
    |> elem(0)
    |> calc(count, point)
  end
  
  def do_part_1(recipes, positions, count, point) when length(recipes) >= count + point, do: recipes
  def do_part_1(recipes, positions, count, point) do
    {recipes, positions}
    |> iterate()
    |> do_part_1()
  end
  
  def calc(recipes, count, point) do
    recipes
    |> Enum.drop(count)
    |> Enum.take(point)
    |> Enum.join("")
  end

  @doc """
      iex> Day14.iterate({[3, 7], {0, 1}})
      {[3, 7, 1, 0], {0, 1}}
      
      iex> Day14.iterate({[3, 7, 1, 0], {0, 1}})
      {[3, 7, 1, 0, 1, 0], {4, 3}}
      
      iex> Day14.iterate({[3, 7, 1, 0, 1, 0], {4, 3}})
      {[3, 7, 1, 0, 1, 0, 1], {6, 4}}
      
      iex> Day14.iterate({[3, 7, 1, 0, 1, 0, 1], {6, 4}})
      {[3, 7, 1, 0, 1, 0, 1, 2], {0, 6}}
  """
  def iterate({recipes, positions}) do
    rev_current_recipies = Enum.reverse(recipes)
    new_recipes =
      create([Enum.at(recipes, elem(positions, 0)), Enum.at(recipes, elem(positions, 1))])
      |> Enum.reverse
    
    current_recipes =
      [new_recipes | rev_current_recipies]
      |> List.flatten
      |> Enum.reverse
      
    positions = move({current_recipes, positions})
    {current_recipes, positions}
  end
  
  @doc """
      iex> Day14.move({[3, 7], {0, 1}})
      {0, 1}
      
      iex> Day14.move({[3, 7, 1, 0], {0, 1}})
      {0, 1}
      
      iex> Day14.move({[3, 7, 1, 0, 1, 0], {0, 1}})
      {4, 3}
  """
  def move({recipes, positions}) do
    positions
    |> Tuple.to_list
    |> Enum.map(fn position ->
      score = Enum.at(recipes, position)
      rem(position + score + 1, length(recipes))
    end)
    |> List.to_tuple()
  end
  
  @doc """
      iex> Day14.create([3, 7])
      [1, 0]
      
      iex> Day14.create([90, 10])
      [1, 0]
  """
  def create(current_recipes) do
    current_recipes
    |> Enum.flat_map(fn x -> Integer.digits(x) end)
    |> Enum.reverse
    |> Enum.sum
    |> Integer.digits
  end
end
