defmodule Aoc.Day19 do
  @doc """
      iex> "priv/day19/example.txt" |> Aoc.Day19.input() |> Aoc.Day19.part1()
      19114
  """
  def part1({workflows, ratings}) do
    workflows
    |> IO.inspect(label: "workflows")

    ratings
    |> IO.inspect(label: "ratings")
    |> Enum.filter(fn rating ->
      rate(workflows, "in", rating) == :accepted
    end)
    |> Enum.map(fn rating ->
      point(rating)
    end)
    |> Enum.sum()
  end

  def point(%{"a" => a, "m" => m, "s" => s, "x" => x}), do: a + m + s + x

  def rate(workflows, flow, rating) do
    workflow =
      workflows
      |> Map.get(flow)

    nw =
      Map.get(workflow, :conds)
      |> Enum.reduce_while(Map.get(workflow, :else_cond), fn %{
                                                               "category" => cat,
                                                               "operation" => op,
                                                               "amount" => amt,
                                                               "workflow" => wf
                                                             },
                                                             acc ->
        case op do
          ">" ->
            if Map.get(rating, cat) > String.to_integer(amt), do: {:halt, wf}, else: {:cont, acc}

          "<" ->
            if Map.get(rating, cat) < String.to_integer(amt), do: {:halt, wf}, else: {:cont, acc}
        end
      end)
      |> IO.inspect(label: "match -")

    case nw do
      "A" -> :accepted
      "R" -> :rejected
      _ -> rate(workflows, nw, rating)
    end
  end

  @doc """
      iex> "ex{x>10:one,m<20:two,a>30:R,A}" |> Aoc.Day19.parse_workflow()
      {"ex", %{conds: [%{"amount" => "10", "category" => "x", "operation" => ">", "workflow" => "one"}, %{"amount" => "20", "category" => "m", "operation" => "<", "workflow" => "two"}, %{"amount" => "30", "category" => "a", "operation" => ">", "workflow" => "R"}], else_cond: "A"}}
  """
  def parse_workflow(string) do
    %{"name" => name, "rest" => rest} = Regex.named_captures(~r/(?<name>.*){(?<rest>.*)}/, string)

    [else_cond | suler] =
      rest
      |> String.split(",", trim: true)
      |> Enum.reverse()

    conds =
      suler
      |> Enum.reverse()
      |> Enum.map(fn piece ->
        Regex.named_captures(
          ~r/(?<category>.*)(?<operation>>|<)(?<amount>\d+):(?<workflow>.*)/,
          piece
        )
      end)

    {name, %{conds: conds, else_cond: else_cond}}
  end

  @doc """
      iex> "{x=787,m=2655,a=1222,s=2876}" |> Aoc.Day19.parse_rating()
      %{"a" => 1222, "m" => 2655, "s" => 2876, "x" => 787}

      iex> "{x=2461,m=1339,a=466,s=291}" |> Aoc.Day19.parse_rating()
      %{"a" => 466, "m" => 1339, "s" => 291, "x" => 2461}
  """
  def parse_rating(string) do
    ~r/{x=(?<x>\d+),m=(?<m>\d+),a=(?<a>\d+),s=(?<s>\d+)}/
    |> Regex.named_captures(string)
    |> Enum.map(fn {k, v} -> {k, String.to_integer(v)} end)
    |> Enum.into(%{})
  end

  @doc """
      # iex> "priv/day19/example.txt" |> Aoc.Day19.input() |> Aoc.Day19.part2()
      # 952408144115
  """
  def part2(map) do
  end

  def input(filename) do
    [rules, vals] =
      filename
      |> File.read!()
      |> String.split("\n\n", trim: true)

    workflows =
      rules
      |> String.split("\n", trim: true)
      |> Enum.map(fn rule ->
        parse_workflow(rule)
      end)
      |> Enum.into(%{})

    ratings =
      vals
      |> String.split("\n", trim: true)
      |> Enum.map(fn val -> parse_rating(val) end)

    {workflows, ratings}
  end
end
