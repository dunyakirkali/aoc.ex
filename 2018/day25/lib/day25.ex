defmodule Day25 do
  use Memoize
  @moduledoc """
  Documentation for Day25.
  """

  def number_of_constellations(input) do
    constellations = 
      input
      |> points()
      |> Enum.reduce([], fn point, groups ->
        group_index = 
          Enum.find_index(groups, fn group ->
            in_constellation?(group, point)
          end)
        
        if group_index == nil do
          [[point] | groups]
        else
          group = Enum.at(groups, group_index)
          List.replace_at(groups, group_index, [point | group])
        end
      end)
    
    # IO.inspect(constellations)
    Enum.reduce(constellations, [], fn cons_a, acc ->
      Enum.reduce(constellations, acc, fn cons_b, acc ->
        if cons_a != cons_b do
          if mergable?(cons_a, cons_b) do
            # IO.inspect(cons_a ++ cons_b, label: "Merge")
            [[cons_a ++ cons_b] | acc]
          else
            # IO.inspect([cons_a | acc], label: "No Merge")
            [cons_a | acc]
          end
        else
          acc
        end
      end)
    end)
    # |> IO.inspect(label: "results")
    |> Enum.count
    |> Kernel./(2)
  end
  
  @doc """
      iex> Day25.mergable?([{12, 0, 0, 0}, {9, 0, 0, 0}], [
      ...>   {0, 0, 0, 6},
      ...>   {0, 0, 0, 3},
      ...>   {0, 0, 3, 0},
      ...>   {0, 3, 0, 0},
      ...>   {3, 0, 0, 0},
      ...>   {0, 0, 0, 0}
      ...>  ])
      true
  """
  def mergable?(cons_a, cons_b) do
    cons_a
    |> Enum.map(fn star_a ->
      in_constellation?(cons_b, star_a)
    end)
    |> Enum.any?
  end
  
  defmemo points(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(",")
      |> Enum.map(&(String.to_integer(&1)))
      |> List.to_tuple
    end)
  end
  
  @doc """
      iex> Day25.in_constellation?([{0,0,3,0}, {0,0,0,3}], {0,0,0,6})
      true
      
      iex> Day25.in_constellation?([{0,0,3,0}, {0,0,0,3}], {9,0,0,0})
      false
  """
  defmemo in_constellation?(constellation, point) do
    constellation
    |> Enum.map(fn star ->
      man_dist(star, point) < 4
    end)
    |> Enum.any?
  end
  
  @doc """
      iex> Day25.man_dist({0,0,0,0}, {3,0,0,0})
      3
      
      iex> Day25.man_dist({0,4,5,0}, {3,0,0,6})
      18
      
      iex> Day25.man_dist({1,-1,0,1}, {2,0,-1,0})
      4
  """
  defmemo man_dist(a, b) do
    abs(elem(a, 0) - elem(b, 0)) +
    abs(elem(a, 1) - elem(b, 1)) +
    abs(elem(a, 2) - elem(b, 2)) +
    abs(elem(a, 3) - elem(b, 3))
  end
end
