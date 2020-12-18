defmodule Aoc.Day18 do
  @doc """
      iex> Aoc.Day18.part1(["2 * 3 + (4 * 5)"])
      26

      iex> Aoc.Day18.part1(["5 + (8 * 3 + 9 + 3 * 4 * 3)"])
      437

      iex> Aoc.Day18.part1(["5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))"])
      12240

      iex> Aoc.Day18.part1(["((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"])
      13632
  """
  def part1(inp) do
    inp
    |> run([{"*", "-"}])
  end

  @doc """
      iex> Aoc.Day18.part2(["1 + (2 * 3) + (4 * (5 + 6))"])
      51

      iex> Aoc.Day18.part2(["2 * 3 + (4 * 5)"])
      46

      iex> Aoc.Day18.part2(["5 + (8 * 3 + 9 + 3 * 4 * 3)"])
      1445

      iex> Aoc.Day18.part2(["5 * 9 * (7 * 3 * 3 + 9 * 3 + (8 + 6 * 4))"])
      669060

      iex> Aoc.Day18.part2(["((2 + 4 * 9) * (6 + 9 * 8 + 6) + 6) + 2 + 4 * 2"])
      23340
  """
  def part2(inp) do
    inp
    |> run([{"*", "-"}, {"+", "/"}])
  end

  defp replace(str, []), do: str

  defp replace(str, [{match, replacement} | rest]),
    do: String.replace(str, match, replacement) |> replace(rest)

  def parse_with_replacement(line, replace) do
    {:ok, quoted} = replace(line, replace) |> Code.string_to_quoted()
    quoted
  end

  defp replace_operation(num, _replacement) when is_integer(num), do: num

  defp replace_operation({operator, metadata, [a, b]}, replace) do
    {replace[operator] || operator, metadata,
     [replace_operation(a, replace), replace_operation(b, replace)]}
  end

  def run(input, replace) do
    revert = Enum.map(replace, fn {m, r} -> {String.to_atom(r), String.to_atom(m)} end)

    Enum.map(input, fn line ->
      {result, []} =
        parse_with_replacement(line, replace)
        |> replace_operation(revert)
        |> Code.eval_quoted()

      result
    end)
    |> Enum.sum()
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
