defmodule Aoc.Day1 do

  def part1() do
    input()
    |> Enum.map(&(fuel_for(&1)))
    |> Enum.sum()
  end

  def part2() do
    input()
    |> Enum.map(&(corrected_fuel_for(&1)))
    |> Enum.sum()
  end

  @doc """
      iex> Aoc.Day1.corrected_fuel_for(14)
      2

      iex> Aoc.Day1.corrected_fuel_for(1969)
      966

      iex> Aoc.Day1.corrected_fuel_for(100756)
      50346
  """
  def corrected_fuel_for(mass) when round(div(mass, 3)) - 2 <= 0, do: 0
  def corrected_fuel_for(mass) do
    fuel = round(div(mass, 3)) - 2
    fuel + corrected_fuel_for(fuel)
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
    "priv/day1/input.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      String.to_integer(x)
    end)
  end
end
