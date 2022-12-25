defmodule Aoc.Day21 do
  use Genex
  use Agent
  use Genex.Tools

  def start do
    Agent.start_link(fn -> {[], "", 0} end, name: __MODULE__)
  end

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
            div(solve(rules, ca1), solve(rules, ca2))

          <<ca1::binary-size(4), " - ", ca2::binary-size(4)>> ->
            solve(rules, ca1) - solve(rules, ca2)
        end

      {no, _} ->
        no
    end
  end

  @doc """
      iex> "priv/day21/example.txt" |> Aoc.Day21.input() |> Aoc.Day21.part2()
      301
  """
  def part2(numbers) do
    start()

    {monkey, goal} = solve_goal(numbers, "root")

    Agent.update(__MODULE__, fn _ ->
      {numbers, monkey, Integer.to_string(goal) |> String.pad_leading(15, "0")}
    end)

    res =
      run(
        population_size: 500,
        mutation_type: Mutation.scramble(),
        mutation_rate: 0.1,
        selection_type: Selection.roulette(),
      )

    stop()

    res.strongest.genes
    |> List.to_string()
    |> IO.inspect()
    |> String.to_integer()
  end

  def stop() do
    Agent.stop(__MODULE__)
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
                div(solve_goal(rules, ca1), solve_goal(rules, ca2))

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
                div(solve_human(rules, ca1, answer), solve_human(rules, ca2, answer))

              <<ca1::binary-size(4), " - ", ca2::binary-size(4)>> ->
                solve_human(rules, ca1, answer) - solve_human(rules, ca2, answer)
            end

          {no, _} ->
            no
        end
    end
  end

  def crossover_rate(population), do: 0.60
  def mutation_rate(population), do: 0.08
  def radiation(population), do: 0.50

  def genotype, do: for(_ <- 1..15, do: Enum.random(?0..?9))

  def fitness_function(c) do
    {rules, monkey, goal} = Agent.get(__MODULE__, fn acc -> acc end)

    resu =
      c.genes
      |> List.to_string()
      |> String.to_integer()
      |> then(fn human ->
        solve_human(rules, monkey, human)
      end)
      |> Integer.to_string()
      |> String.pad_leading(15, "0")

    # if String.jaro_distance(resu, goal) == 1.0 do
    #   String.jaro_distance(resu, goal) |> IO.inspect(label: "dist")
    #   {resu, goal} |> IO.inspect()
    # end
    String.jaro_distance(resu, goal)# |> IO.inspect()
  end

  def terminate?(p) do
    p.max_fitness == 1.0
  end
end
