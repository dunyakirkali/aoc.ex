defmodule Aoc.Day7 do
  @doc """
      iex> "priv/day7/example.txt" |> Aoc.Day7.input() |> Aoc.Day7.part1()
      3749
  """
  def part1(list) do
    list
    |> Enum.filter(fn {test_val, nums} ->
      generate_combinations(nums, ["+", "*"])
      |> Enum.map(fn equ ->
        evaluate(equ)
      end)
      |> Enum.member?(test_val)
    end)
    |> Enum.map(fn {test_val, _} -> test_val end)
    |> Enum.sum()
  end

  def evaluate(equation) do
    equation
    |> String.split(~r/(\+|\*|\|\|)/, trim: true, include_captures: true)
    |> evaluate_left_to_right()
  end

  defp evaluate_left_to_right([number]), do: String.to_integer(number)

  defp evaluate_left_to_right([left, operator, right | rest]) do
    result =
      case operator do
        "+" -> String.to_integer(left) + String.to_integer(right)
        "*" -> String.to_integer(left) * String.to_integer(right)
        "||" -> String.to_integer(left <> right)
      end

    evaluate_left_to_right([Integer.to_string(result) | rest])
  end

  def generate_combinations(numbers, operators) do
    generate_combinations(numbers, operators, [])
  end

  defp generate_combinations([number], _operators, acc) do
    # When there's only one number left, combine it with the accumulator
    [Enum.join(acc ++ [to_string(number)], "")]
  end

  defp generate_combinations([first, second | rest], operators, acc) do
    for operator <- operators,
        combination <-
          generate_combinations([second | rest], operators, acc ++ [to_string(first), operator]) do
      combination
    end
  end

  @doc """
      iex> "priv/day7/example.txt" |> Aoc.Day7.input() |> Aoc.Day7.part2()
      11387
  """
  def part2(list) do
    list
    |> Enum.filter(fn {test_val, nums} ->
      generate_combinations(nums, ["+", "*", "||"])
      |> Stream.map(&evaluate/1)
      |> Enum.any?(&(&1 == test_val))
    end)
    |> Enum.map(fn {test_val, _} -> test_val end)
    |> Enum.sum()
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [test_val, nums_s] =
        line
        |> String.split(": ", trim: true)

      nums =
        nums_s
        |> String.split(" ", trim: true)
        |> Enum.map(&String.to_integer/1)

      {String.to_integer(test_val), nums}
    end)
  end
end
