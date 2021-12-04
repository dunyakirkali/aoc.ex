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
      |> Enum.map(fn {board, player} ->
        board =
          board
          |> Enum.map(fn line ->
            List.delete(line, h)
          end)

        {board, player}
      end)

    winners = winning_board(boards)

    if winners == nil do
      play(t, boards)
    else
      {board, _player} = winners |> List.first

      board
      |> List.flatten()
      |> Enum.sum()
      |> Kernel.*(h)
    end
  end

  def winning_board(boards) do
    check_row =
      boards
      |> Enum.map(fn {board, player} ->
        board
        |> Enum.reduce_while(nil, fn line, _acc ->
          if length(line) == 0 do
            {:halt, {board, player}}
          else
            {:cont, nil}
          end
        end)
      end)

    check_col =
      boards
      |> Enum.map(fn {board, player} ->
        board
        |> Enum.zip()
        |> Enum.map(&Tuple.to_list/1)
        |> Enum.reduce_while(nil, fn line, _acc ->
          if length(line) == 0 do
            {:halt, {board, player}}
          else
            {:cont, nil}
          end
        end)
      end)

    winners_row =
      check_row
      |> Enum.filter(fn x -> x != nil end)
      |> length()
      |> Kernel.!=(0)

    winners_col =
      check_col
      |> Enum.filter(fn x -> x != nil end)
      |> length()
      |> Kernel.!=(0)

    if winners_row or winners_col do
      Enum.filter(check_row, fn x -> x != nil end) ++ Enum.filter(check_col, fn x -> x != nil end)
    else
      nil
    end
  end

  # @doc """
  #     iex> input = Aoc.Day4.input("priv/day4/example.txt")
  #     ...> Aoc.Day4.part2(input)
  #     1924
  # """
  def part2(input) do
    {numbers, boards} = input
    play2(numbers, boards)
  end

  defp play2([], _), do: raise "WAT"
  defp play2([h | t], boards) do
    IO.inspect(h)
    boards =
      boards
      |> Enum.map(fn {board, player} ->
        board =
          board
          |> Enum.map(fn line ->
            List.delete(line, h)
          end)

        {board, player}
      end)


    winners = winning_board(boards)
    |> IO.inspect(label: "winners")

    if winners == nil do
      play2(t, boards)
    else
      boards = boards -- winners
      |> IO.inspect(label: "boards")

      if length(boards) == 1 do
        {board, _player} = boards |> List.first()
        [f | _] = t

        board
        |> List.flatten()
        |> Enum.sum()
        |> Kernel.-(f)
        |> Kernel.*(f)
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
        |> Enum.map(fn line ->
          line
          |> String.split(" ", trim: true)
          |> Enum.map(&String.to_integer/1)
        end)
      end)
      |> Enum.with_index()

    {nums, boards}
  end
end
