defmodule Aoc.Day4 do
  @doc """
      iex> input = Aoc.Day4.input("priv/day4/example.txt")
      ...> Aoc.Day4.part1(input)
      4512
  """
  def part1(input) do
    {numbers, boards} = input
    play(numbers, boards)
  end

  defp play([h | t], boards) do
    boards =
      boards
      |> Enum.map(fn board ->
        board
        |> Enum.filter(fn {_key, val} ->
           val != h
        end)
        |> Enum.into(%{})
        # Only available in 1.13.0
        # Map.reject(board, fn {_key, val} -> val == h end)
      end)

    winners = winning_board(boards)

    if Enum.empty?(winners) do
      play(t, boards)
    else
      winners
      |> List.first()
      |> Map.values()
      |> Enum.sum()
      |> Kernel.*(h)
    end
  end

  def winning_board(boards) do
    boards
    |> Enum.filter(fn board ->
      won_row =
        0..4
        |> Enum.map(fn row ->
          win_row?(board, row)
        end)
        |> Enum.any?()

      won_col =
        0..4
        |> Enum.map(fn col ->
          win_col?(board, col)
        end)
        |> Enum.any?()

      won_row or won_col
    end)
  end

  defp win_row?(board, row) do
    coords = for x <- 0..4, y <- [row], do: {x, y}

    coords
    |> Enum.map(fn coord ->
      board
      |> Map.has_key?(coord)
      |> Kernel.not()
    end)
    |> Enum.all?()
  end

  defp win_col?(board, col) do
    coords = for x <- [col], y <- 0..4, do: {x, y}

    coords
    |> Enum.map(fn coord ->
      board
      |> Map.has_key?(coord)
      |> Kernel.not()
    end)
    |> Enum.all?()
  end

  @doc """
      iex> input = Aoc.Day4.input("priv/day4/example.txt")
      ...> Aoc.Day4.part2(input)
      1924
  """
  def part2(input) do
    {numbers, boards} = input
    play2(numbers, boards)
  end

  defp play2([h | t], boards) do
    boards =
      boards
      |> Enum.map(fn board ->
        board
        |> Enum.filter(fn {_key, val} ->
           val != h
        end)
        |> Enum.into(%{})
        # Only available in 1.13.0
        # Map.reject(board, fn {_key, val} -> val == h end)
      end)

    winners = winning_board(boards)

    if Enum.empty?(winners) do
      play2(t, boards)
    else
      boards = boards -- winners

      if length(boards) == 0 do
        winners
        |> List.first()
        |> Map.values()
        |> Enum.sum()
        |> Kernel.*(h)
      else
        play2(t, boards)
      end
    end
  end

  def input(filename) do
    raw =
      filename
      |> File.read!()
      |> String.split("\n", trim: true)

    [nums | rest] = raw
    nums = String.split(nums, ",") |> Enum.map(&String.to_integer/1)

    boards =
      rest
      |> Enum.chunk_every(5, 5)
      |> Enum.map(fn board ->
        board
        |> Enum.with_index()
        |> Enum.reduce(%{}, fn {line, y}, acc ->
          line
          |> String.split(" ", trim: true)
          |> Enum.map(&String.to_integer/1)
          |> Enum.with_index()
          |> Enum.reduce(acc, fn {cell, x}, acc ->
            Map.put(acc, {x, y}, cell)
          end)
        end)
      end)

    {nums, boards}
  end
end
