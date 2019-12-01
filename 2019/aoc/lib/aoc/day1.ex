defmodule Aoc.Day1 do

  def part1() do
    input()
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      x
      |> String.to_integer
      |> fuel_for()
    end)
    |> Enum.sum
  end

  def part2() do
    input()
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      x
      |> String.to_integer
      |> corrected_fuel_for()
    end)
    |> Enum.sum
  end

  @doc """
      iex> Aoc.Day1.corrected_fuel_for(14)
      2

      iex> Aoc.Day1.corrected_fuel_for(1969)
      966

      iex> Aoc.Day1.corrected_fuel_for(100756)
      50346
  """
  # def corrected_fuel_for(mass) when mass <= 0, do: 0
  def corrected_fuel_for(mass) do
    fuel =
      mass
      |> div(3)
      |> round()
      |> Kernel.-(2)

    if fuel > 0 do
      fuel + corrected_fuel_for(fuel)
    else
      0
    end
  end

  @doc """
      iex> Aoc.Day1.fuel_for(12)
      2

      iex> Aoc.Day1.fuel_for(14)
      2

      iex> Aoc.Day1.fuel_for(1969)
      654

      iex> Aoc.Day1.fuel_for(100756)
      33583
  """
  def fuel_for(mass) do
    mass
    |> div(3)
    |> round()
    |> Kernel.-(2)
  end

  defp input() do
    Aoc.read("priv/day1/input.txt")
  end
end
