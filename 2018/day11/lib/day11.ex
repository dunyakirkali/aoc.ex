defmodule Day11 do
  @moduledoc """
  Documentation for Day11.
  """

  @doc """
      iex> Day11.part_2(18)
      %{coords: {90, 269}, power: 113}

      iex> Day11.part_2(42)
      %{coords: {232, 251}, power: 119}
  """
  def part_2(serial_number) do
    1..300
    |> Enum.map(fn size ->
      max = part_1(serial_number, size)
      IO.puts(
        "For #{size}x#{size} max is @#{elem(max[:coords], 0)}x#{elem(max[:coords], 1)} with power #{
          max[:power]
        }"
      )
      max
    end)
    |> Enum.sort_by(fn %{coords: _, power: power} ->
      power
    end)
    |> List.last()
  end

  @doc """
      iex> Day11.part_1(18)
      %{coords: {33, 45}, power: 29}

      iex> Day11.part_1(18, 16)
      %{coords: {90, 269}, power: 113}

      iex> Day11.part_1(42, 12)
      %{coords: {232, 251}, power: 119}
  """
  def part_1(serial_number, size \\ 3) do
    grid =
      Enum.reduce(1..300, %{}, fn x, acc ->
        Enum.reduce(1..300, acc, fn y, acc ->
          Map.put(acc, {x, y}, adjusted_power_level({x, y}, serial_number))
        end)
      end)

    grid
    |> Stream.map(fn cell ->
      total_power =
        elem(cell, 0)
        |> neighbours(size)
        |> Enum.map(fn neighbour ->
          grid[neighbour]
        end)
        |> Enum.sum()

      %{coords: elem(cell, 0), power: total_power}
    end)
    |> Enum.sort_by(fn %{coords: _, power: power} ->
      power
    end)
    |> List.last()
  end

  @doc """
      iex> Day11.rack_id({3, 5})
      13

      iex> Day11.rack_id({9, 29})
      19
  """
  def rack_id(cell) do
    elem(cell, 0) + 10
  end

  @doc """
      iex> Day11.power_level({3, 5})
      65

      iex> Day11.power_level({9, 29})
      551
  """
  def power_level(cell) do
    cell
    |> rack_id()
    |> Kernel.*(elem(cell, 1))
  end

  @doc """
      iex> Day11.adjusted_power_level({3, 5}, 8)
      4

      iex> Day11.adjusted_power_level({122, 79}, 57)
      -5

      iex> Day11.adjusted_power_level({217, 196}, 39)
      0

      iex> Day11.adjusted_power_level({101, 153}, 71)
      4
  """
  def adjusted_power_level(cell, serial_number) do
    cell
    |> set(serial_number)
    |> hundreds_digit()
    |> Kernel.-(5)
  end

  @doc """
      iex> Day11.increase({3, 5}, 8)
      73

      iex> Day11.increase({9, 29}, 8)
      559
  """
  def increase(cell, serial_number) do
    cell
    |> power_level()
    |> Kernel.+(serial_number)
  end

  @doc """
      iex> Day11.set({3, 5}, 8)
      949

      iex> Day11.set({9, 29}, 8)
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
    |> div(100)
    |> Kernel.trunc()
    |> rem(10)
  end

  @doc """
      iex> Day11.neighbours({1, 1})
      [
        {1, 1},
        {1, 2},
        {1, 3},
        {2, 1},
        {2, 2},
        {2, 3},
        {3, 1},
        {3, 2},
        {3, 3}
      ]
  """
  def neighbours(cell, size \\ 3) do
    x = elem(cell, 0)
    y = elem(cell, 1)
    maxX = min(300, x + size - 1)
    maxY = min(300, y + size - 1)
    for x <- Enum.to_list(x..maxX),
        y <- Enum.to_list(y..maxY),
        do: {x, y}
  end
end
