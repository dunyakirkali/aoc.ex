defmodule Aoc.Day1 do
  @doc """
      iex> "priv/day1/example.txt" |> Aoc.Day1.input() |> Aoc.Day1.part1()
      142
  """
  def part1(list) do
    list
    |> Enum.map(fn line ->
      numbers =
        line
        |> String.graphemes()
        |> Enum.map(fn x ->
          case Integer.parse(x) do
            {num, _} -> num
            _ -> nil
          end
        end)
        |> Enum.filter(&(!is_nil(&1)))

      fi = List.first(numbers)
      la = List.last(numbers)

      [fi, la] |> Integer.undigits()
    end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day1/example2.txt" |> Aoc.Day1.input() |> Aoc.Day1.part2()
      281
  """
  def part2(list) do
    list
    |> Enum.map(fn line ->
      line_s = start(line, "")
      line_e = endd(line, "")

      numbers =
        line_s
        |> String.graphemes()
        |> Enum.map(fn x ->
          case Integer.parse(x) do
            {num, _} -> num
            _ -> nil
          end
        end)
        |> Enum.filter(&(!is_nil(&1)))

      fi = List.first(numbers)

      numbers =
        line_e
        |> String.graphemes()
        |> Enum.map(fn x ->
          case Integer.parse(x) do
            {num, _} -> num
            _ -> nil
          end
        end)
        |> Enum.filter(&(!is_nil(&1)))

      la = List.last(numbers)

      [fi, la] |> Integer.undigits()
    end)
    |> Enum.sum()
  end

  def start("", acc), do: acc

  def start(line, acc) do
    rpl =
      cond do
        String.starts_with?(line, "one") -> String.replace(line, "one", "1")
        String.starts_with?(line, "two") -> String.replace(line, "two", "2")
        String.starts_with?(line, "three") -> String.replace(line, "three", "3")
        String.starts_with?(line, "four") -> String.replace(line, "four", "4")
        String.starts_with?(line, "five") -> String.replace(line, "five", "5")
        String.starts_with?(line, "six") -> String.replace(line, "six", "6")
        String.starts_with?(line, "seven") -> String.replace(line, "seven", "7")
        String.starts_with?(line, "eight") -> String.replace(line, "eight", "8")
        String.starts_with?(line, "nine") -> String.replace(line, "nine", "9")
        true -> line
      end

    {f, r} = String.split_at(rpl, 1)
    start(r, acc <> f)
  end

  def endd("", acc), do: acc

  def endd(line, acc) do
    rpl =
      cond do
        String.ends_with?(line, "one") -> String.replace(line, "one", "1")
        String.ends_with?(line, "two") -> String.replace(line, "two", "2")
        String.ends_with?(line, "three") -> String.replace(line, "three", "3")
        String.ends_with?(line, "four") -> String.replace(line, "four", "4")
        String.ends_with?(line, "five") -> String.replace(line, "five", "5")
        String.ends_with?(line, "six") -> String.replace(line, "six", "6")
        String.ends_with?(line, "seven") -> String.replace(line, "seven", "7")
        String.ends_with?(line, "eight") -> String.replace(line, "eight", "8")
        String.ends_with?(line, "nine") -> String.replace(line, "nine", "9")
        true -> line
      end

    {f, r} = String.split_at(rpl, String.length(rpl) - 1)
    endd(f, r <> acc)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
