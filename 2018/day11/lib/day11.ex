defmodule Day11 do
  @moduledoc """
  Documentation for Day11.
  """

  @doc """
      iex> Day11.part_2(18)
      %{coords: {90, 269}, power: 113}

      # iex> Day11.part_2(42)
      # %{coords: {232, 251}, power: 119}
  """
  def part_2(serial_number) do
    range = 1..300
    sizes = for x <- Enum.to_list(range), y <- Enum.to_list(range), do: %{x: x, y: y}
    result =
      sizes
      |> Enum.filter(fn size ->
        size[:x] == size[:y]
      end)
      |> pmap(fn size ->
        max = part_1(serial_number, size)
        IO.puts("For #{size[:x]}x#{size[:y]} max is @#{elem(max[:coords], 0)}x#{elem(max[:coords], 1)} with power #{max[:power]}")
        max
      end)
    |> Enum.sort_by(fn %{coords: _, power: power} ->
      power
    end)
    |> List.last
    |> IO.inspect
  end

  @doc """
      iex> Day11.part_1(18)
      %{coords: {33, 45}, power: 29}

      iex> Day11.part_1(18, %{x: 16, y: 16})
      %{coords: {90, 269}, power: 113}

      iex> Day11.part_1(42, %{x: 12, y: 12})
      %{coords: {232, 251}, power: 119}
  """
  def part_1(serial_number, size \\ %{x: 3, y: 3}) do
    grid = for x <- Enum.to_list(1..(300 - size[:x] + 1)), y <- Enum.to_list(1..(300 - size[:y] + 1)), do: %{x: x, y: y}
    result =
      grid
      |> Enum.map(fn cell ->
        total_power =
          cell
          |> Day11.neighbours(size)
          |> Enum.map(fn neighbour ->
            Day11.adjusted_power_level(neighbour, serial_number)
          end)
          |> Enum.sum

        %{coords: {cell[:x], cell[:y]}, power: total_power}
      end)
      |> Enum.sort_by(fn %{coords: _, power: power} ->
        power
      end)
      |> List.last
  end

  def pmap(collection, func) do
    collection
    |> Enum.map(&(Task.async(fn -> func.(&1) end)))
    |> Enum.map(&Task.await(&1, 60_000_000))
  end

  @doc """
      iex> Day11.rack_id(%{x: 3, y: 5})
      13

      iex> Day11.rack_id(%{x: 9, y: 29})
      19
  """
  def rack_id(cell) do
    cell[:x] + 10
  end

  @doc """
      iex> Day11.power_level(%{x: 3, y: 5})
      65

      iex> Day11.power_level(%{x: 9, y: 29})
      551
  """
  def power_level(cell) do
    cell
    |> rack_id()
    |> Kernel.*(cell[:y])
  end

  @doc """
      iex> Day11.adjusted_power_level(%{x: 3, y: 5}, 8)
      4

      iex> Day11.adjusted_power_level(%{x: 122, y: 79}, 57)
      -5

      iex> Day11.adjusted_power_level(%{x: 217, y: 196}, 39)
      0

      iex> Day11.adjusted_power_level(%{x: 101, y: 153}, 71)
      4
  """
  def adjusted_power_level(cell, serial_number) do
    cell
    |> set(serial_number)
    |> hundreds_digit()
    |> Kernel.-(5)
  end

  @doc """
      iex> Day11.increase(%{x: 3, y: 5}, 8)
      73

      iex> Day11.increase(%{x: 9, y: 29}, 8)
      559
  """
  def increase(cell, serial_number) do
    cell
    |> power_level()
    |> Kernel.+(serial_number)
  end

  @doc """
      iex> Day11.set(%{x: 3, y: 5}, 8)
      949

      iex> Day11.set(%{x: 9, y: 29}, 8)
      10_621
  """
  def set(cell, serial_number) do
    cell
    |> increase(serial_number)
    |> Kernel.*(rack_id(cell))
  end

  @doc """
      iex> Day11.hundreds_digit(949)
      9

      iex> Day11.hundreds_digit(12345)
      3
  """
  def hundreds_digit(number) do
    number
    |> Integer.digits()
    |> Enum.at(-3)
  end

  @doc """
      iex> Day11.neighbours(%{x: 1, y: 1})
      [
        %{x: 1, y: 1},
        %{x: 1, y: 2},
        %{x: 1, y: 3},
        %{x: 2, y: 1},
        %{x: 2, y: 2},
        %{x: 2, y: 3},
        %{x: 3, y: 1},
        %{x: 3, y: 2},
        %{x: 3, y: 3}
      ]
  """
  def neighbours(cell, size \\ %{x: 3, y: 3}) do
    for x <- Enum.to_list((cell[:x])..(cell[:x] + size[:x] - 1)),
        y <- Enum.to_list((cell[:y])..(cell[:y] + size[:y] - 1)),
        do: %{x: x, y: y}
  end
end
