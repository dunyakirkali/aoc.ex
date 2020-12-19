defmodule Aoc.Day19 do
  @doc """
      iex> inp = Aoc.Day19.input("priv/day19/example.txt")
      ...> Aoc.Day19.part1(inp)
      2
  """
  def part1([rules, messages]) do
    tree = parse_rules(rules)

    messages
    |> Enum.filter(fn x ->
      read(tree, x, "0") == ""
    end)
    |> Enum.count()
  end

  def part2([rules, messages]) do
    tree =
      rules
      |> Enum.map(fn x ->
        case x do
          "0: 8 11" -> "0: 8"
          "8: 42" -> "8: 42 11 | 42 8"
          "11: 42 31" -> "11: 42 31 | 42 11 31"
          _ -> x
        end
      end)
      |> parse_rules()

    messages
    |> Enum.filter(fn x ->
      read(tree, x, "0") == ""
    end)
    |> Enum.count()
  end

  def read(_rules, "a" <> rest, "a") do
    rest
  end

  def read(_rules, "b" <> rest, "b") do
    rest
  end

  def read(_rules, _no_match, char) when char in ["a", "b"] do
    nil
  end

  def read(rules, line, rule) do
    Enum.find_value(rules[rule], fn branch ->
      Enum.reduce(branch, line, fn rule, line ->
        line && read(rules, line, rule)
      end)
    end)
  end

  def parse_rules(rules) do
    rules
    |> Enum.map(fn rule ->
      rule
      |> String.split(": ", trim: true)
    end)
    |> Enum.map(fn [no, rule] ->
      ro =
        rule
        |> String.replace("\"", "")
        |> String.split(" | ")
        |> Enum.map(&String.split/1)

      {no, ro}
    end)
    |> Enum.into(%{})
  end

  # @doc """
  #     iex> Aoc.Day19.part2(["1 + (2 * 3) + (4 * (5 + 6))"])
  #     51
  # """
  # def part2(inp) do
  # end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.map(fn group ->
      group
      |> String.split("\n", trim: true)
    end)
  end
end
