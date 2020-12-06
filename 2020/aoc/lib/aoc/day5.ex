defmodule Aoc.Day5 do
  def part1(inp) do
    inp
    |> Enum.map(fn row ->
      row
      |> run()
      |> seat_id
    end)
    |> Enum.max()
  end

  def part2(inp) do
    seat_ids =
      inp
      |> Enum.map(fn row ->
        row
        |> run()
        |> seat_id
      end)
      |> Enum.sort()

    0..Enum.max(seat_ids)
    |> Enum.chunk_every(3, 1, :discard)
    |> Enum.find(fn [s1, s2, s3] ->
      Enum.member?(seat_ids, s1) && !Enum.member?(seat_ids, s2) && Enum.member?(seat_ids, s3)
    end)
    |> Enum.at(1)
  end

  @doc """
      iex> Aoc.Day5.run("FBFBBFFRLR")
      {44, 5}

      iex> Aoc.Day5.run("BFFFBBFRRR")
      {70, 7}

      iex> Aoc.Day5.run("FFFBBBFRRR")
      {14, 7}

      iex> Aoc.Day5.run("BBFFBBFRLL")
      {102, 4}
  """
  def run(row) do
    {[row], [col]} =
      row
      |> String.graphemes()
      |> Enum.reduce({Enum.to_list(0..127), Enum.to_list(0..7)}, fn char, {row, col} ->
        case char do
          "F" -> {elem(split(row), 0), col}
          "B" -> {elem(split(row), 1), col}
          "L" -> {row, elem(split(col), 0)}
          "R" -> {row, elem(split(col), 1)}
        end
      end)

    {row, col}
  end

  @doc """
      iex> Aoc.Day5.seat_id({44, 5})
      357

      iex> Aoc.Day5.seat_id({70, 7})
      567

      iex> Aoc.Day5.seat_id({14, 7})
      119

      iex> Aoc.Day5.seat_id({102, 4})
      820
  """
  def seat_id({row, col}) do
    row * 8 + col
  end

  @doc """
      iex> Aoc.Day5.split([1, 2])
      {[1], [2]}

      iex> Aoc.Day5.split([1, 2, 3, 4])
      {[1, 2], [3, 4]}

      iex> Aoc.Day5.split([1, 2, 3, 4, 5])
      {[1, 2, 3], [4, 5]}
  """
  def split(list) do
    len = round(length(list) / 2)
    Enum.split(list, len)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
