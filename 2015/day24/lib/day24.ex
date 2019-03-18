defmodule Day24 do
  import Combination
  
  def part_2(packages) do
    part_1(packages, 4)
  end

  @doc """
      iex> Day24.part_1([1, 2, 3, 4, 5, 7, 8, 9, 10, 11])
      99
  """
  def part_1(packages, length \\ 3) do
    sub_sum =
      packages
      |> Enum.sum()
      |> Kernel.div(length)
      |> Kernel.trunc()
      |> IO.inspect
    
    right_size =
      1..length(packages)
      |> Enum.reduce_while(1, fn size, acc ->
        
        combinations = Combination.combine(packages, size)
        
        if Enum.any?(combinations, fn list ->
          Enum.sum(list) == sub_sum
        end) do
          {:halt, size}
        else
          {:cont, size}
        end
      end)
    
    packages
    |> Combination.combine(right_size)
    |> Enum.filter(fn list ->
      Enum.sum(list) == sub_sum
    end)
    |> Enum.sort_by(fn list ->
      quantum_entaglement(list)
    end)
    |> List.first
    |> quantum_entaglement
  end
  
  @doc """
      iex> Day24.quantum_entaglement([11, 9])
      99
      
      iex> Day24.quantum_entaglement([10, 9, 1])
      90
      
      iex> Day24.quantum_entaglement([10, 4, 3, 2, 1])
      240
  """
  def quantum_entaglement(list) do
    list
    |> Enum.reduce(1, fn x, acc ->
      acc * x
    end)
  end
end