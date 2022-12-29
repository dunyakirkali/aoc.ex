defmodule Aoc.Day21 do
  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      line
      |> String.split(": ")
    end)
  end

  @doc """
      iex> "priv/day21/example.txt" |> Aoc.Day21.input() |> Aoc.Day21.part1()
      152
  """
  def part1(numbers) do
    numbers
    |> solve("root")
    |> trunc()
  end

  def solve(rules, monkey) do
    [_, ca] = Enum.find(rules, fn [m, _] -> m == monkey end)

    case Integer.parse(ca) do
      :error ->
        case ca do
          <<ca1::binary-size(4), " + ", ca2::binary-size(4)>> ->
            solve(rules, ca1) + solve(rules, ca2)

          <<ca1::binary-size(4), " * ", ca2::binary-size(4)>> ->
            solve(rules, ca1) * solve(rules, ca2)

          <<ca1::binary-size(4), " / ", ca2::binary-size(4)>> ->
            solve(rules, ca1) / solve(rules, ca2)

          <<ca1::binary-size(4), " - ", ca2::binary-size(4)>> ->
            solve(rules, ca1) - solve(rules, ca2)
        end

      {no, _} ->
        no
    end
  end

  @doc """
      iex> "priv/day21/example.txt" |> Aoc.Day21.input() |> Aoc.Day21.part2(true)
      301
  """
  def part2(rules, example \\ false) do
    {monkey, goal} = solve_goal(rules, "root")

    min = 0
    max = 1_000_000_000_000_000_000

    if example do
      search(rules, goal, monkey, max, min)
    else
      search(rules, goal, monkey, min, max)
    end
    |> trunc()
  end

  def search(rules, goal, monkey, min, max) do
    mid = div(min + max, 2)
    res = solve_human(rules, monkey, mid)

    cond do
      res == goal -> mid
      res < goal -> search(rules, goal, monkey, min, mid)
      res > goal -> search(rules, goal, monkey, mid + 1, max)
    end
  end

  def solve_goal(rules, monkey) do
    # IO.inspect(monkey)
    [_, ca] = Enum.find(rules, fn [m, _] -> m == monkey end)

    case monkey do
      "root" ->
        <<ca1::binary-size(4), " + ", ca2::binary-size(4)>> = ca
        {ca1, solve_goal(rules, ca2)}

      "humn" ->
        "Yell\n"
        |> IO.gets()
        |> String.trim()
        |> String.to_integer()

      _ ->
        case Integer.parse(ca) do
          :error ->
            case ca do
              <<ca1::binary-size(4), " + ", ca2::binary-size(4)>> ->
                solve_goal(rules, ca1) + solve_goal(rules, ca2)

              <<ca1::binary-size(4), " * ", ca2::binary-size(4)>> ->
                solve_goal(rules, ca1) * solve_goal(rules, ca2)

              <<ca1::binary-size(4), " / ", ca2::binary-size(4)>> ->
                solve_goal(rules, ca1) / solve_goal(rules, ca2)

              <<ca1::binary-size(4), " - ", ca2::binary-size(4)>> ->
                solve_goal(rules, ca1) - solve_goal(rules, ca2)
            end

          {no, _} ->
            no
        end
    end
  end

  def solve_human(rules, monkey, answer) do
    [_, ca] = Enum.find(rules, fn [m, _] -> m == monkey end)

    case monkey do
      "root" ->
        <<ca1::binary-size(4), " + ", ca2::binary-size(4)>> = ca
        solve_human(rules, ca1, answer) + solve_human(rules, ca2, answer)

      "humn" ->
        answer

      _ ->
        case Integer.parse(ca) do
          :error ->
            case ca do
              <<ca1::binary-size(4), " + ", ca2::binary-size(4)>> ->
                solve_human(rules, ca1, answer) + solve_human(rules, ca2, answer)

              <<ca1::binary-size(4), " * ", ca2::binary-size(4)>> ->
                solve_human(rules, ca1, answer) * solve_human(rules, ca2, answer)

              <<ca1::binary-size(4), " / ", ca2::binary-size(4)>> ->
                solve_human(rules, ca1, answer) / solve_human(rules, ca2, answer)

              <<ca1::binary-size(4), " - ", ca2::binary-size(4)>> ->
                solve_human(rules, ca1, answer) - solve_human(rules, ca2, answer)
            end

          {no, _} ->
            no
        end
    end
  end
end
