defmodule Aoc.Day6 do
  @doc """
      iex> "priv/day6/example.txt" |> Aoc.Day6.input_part1() |> Aoc.Day6.part1()
      4277556
  """
  def part1({nums, cals}) do
    nums
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: true)
      |> Enum.map(&String.to_integer/1)
    end)
    |> Enum.zip()
    |> Enum.with_index()
    |> Enum.map(fn {tuple, i} ->
      tuple
      |> Tuple.to_list()
      |> Enum.reduce(fn x, acc ->
        case Enum.at(cals, i) do
          "*" -> acc * x
          "+" -> acc + x
        end
      end)
    end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day6/example.txt" |> Aoc.Day6.input_part2() |> Aoc.Day6.part2()
      3263827

      iex> "priv/day6/example2.txt" |> Aoc.Day6.input_part2() |> Aoc.Day6.part2()
      706262540
  """
  def part2({nums, bottom_row}) do
    width =
      [bottom_row | nums]
      |> Enum.map(&String.length/1)
      |> Enum.max()

    rows =
      nums
      |> Enum.map(&String.pad_trailing(&1, width))
      |> Enum.map(&String.graphemes/1)

    bottom =
      bottom_row
      |> String.pad_trailing(width)
      |> String.graphemes()

    cols =
      for col <- 0..(width - 1) do
        col_chars = Enum.map(rows, fn r -> Enum.at(r, col) end)
        op_char = Enum.at(bottom, col)
        {col_chars, op_char}
      end

    sep? = fn {col_chars, _op} -> Enum.all?(col_chars, &(&1 == " ")) end

    groups =
      cols
      |> Enum.chunk_by(sep?)
      |> Enum.reject(fn group -> sep?.(hd(group)) end)
      |> Enum.reverse()

    results =
      Enum.map(groups, fn group ->
        op =
          group
          |> Enum.reverse()
          |> Enum.map(fn {_chars, op_char} -> op_char end)
          |> Enum.find("+", fn ch -> ch != " " end)

        nums_in_group =
          group
          |> Enum.map(fn {col_chars, _op_char} ->
            digits = Enum.filter(col_chars, &(&1 =~ ~r/^\d$/))

            case digits do
              [] -> nil
              _ -> digits |> Enum.join() |> String.to_integer()
            end
          end)
          |> Enum.filter(& &1)

        case op do
          "+" -> Enum.sum(nums_in_group)
          "*" -> Enum.reduce(nums_in_group, 1, &*/2)
        end
      end)

    Enum.sum(results)
  end

  def input_part1(filename) do
    lines =
      filename
      |> File.read!()
      |> String.split("\n", trim: true)

    cals =
      List.last(lines)
      |> String.split(" ", trim: true)

    nums =
      Enum.slice(lines, 0, length(lines) - 1)

    {nums, cals}
  end

  def input_part2(filename) do
    lines =
      filename
      |> File.read!()
      |> String.split("\n", trim: true)

    bottom_row = List.last(lines)
    nums = Enum.slice(lines, 0, length(lines) - 1)
    {nums, bottom_row}
  end
end
