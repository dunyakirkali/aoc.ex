defmodule Types.Chromosome do
  @enforce_keys :genes
  @type t :: %__MODULE__{
          genes: Enum.t(),
          size: integer(),
          fitness: number(),
          age: integer(),
          goal: integer()
        }
  defstruct [:genes, size: 0, fitness: 0, age: 0, goal: 0]
end

defmodule Problem do
  alias Types.Chromosome
  @callback genotype(integer()) :: Chromosome.t()
  @callback fitness_function(Chromosome.t()) :: number()
  @callback terminate?(Enum.t(), integer()) :: boolean()
end

defmodule Genetic do
  alias Types.Chromosome

  def initialize(genotype, opts \\ []) do
    population_size = Keyword.get(opts, :population_size, 100)
    goal = Keyword.get(opts, :goal, 100)
    for _ <- 1..population_size, do: genotype.(goal)
  end

  def evaluate(population, fitness_function, opts \\ []) do
    population
    |> Enum.map(fn chromosome ->
      fitness = fitness_function.(chromosome)
      age = chromosome.age + 1
      %Chromosome{chromosome | fitness: fitness, age: age}
    end)
    |> Enum.sort_by(fitness_function, &<=/2)
  end

  def select(population, opts \\ []) do
    population
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple(&1))
  end

  def crossover(population, opts \\ []) do
    Enum.reduce(population, [], fn {p1, p2}, acc ->
      # average = div(Integer.undigits(p1.genes) + Integer.undigits(p2.genes), 2)
      # c1g = Integer.digits(average - 1)
      # c2g = Integer.digits(average + 1)


      # {c1, c2} = {%Chromosome{p1 | genes: c1g}, %Chromosome{p2 | genes: c2g}}

      # [c1, c2 | acc]

      cx_point = :rand.uniform(length(p1.genes))
      {{h1, t1}, {h2, t2}} = {Enum.split(p1.genes, cx_point), Enum.split(p2.genes, cx_point)}
      {c1, c2} = {%Chromosome{p1 | genes: h1 ++ t2}, %Chromosome{p2 | genes: h2 ++ t1}}
      [c1, c2 | acc]
    end)
  end

  def mutation(population, opts \\ []) do
    population
    |> Enum.map(fn chromosome ->
      if :rand.uniform() < 0.05 do
        %Chromosome{chromosome | genes: Enum.shuffle(chromosome.genes)}
      else
        chromosome
      end
    end)
  end

  def evolve(population, problem, generation, opts \\ []) do
    goal = Keyword.get(opts, :goal, 100)
    population = evaluate(population, &problem.fitness_function/1, opts)
    best = hd(population)
    IO.write("\rCurrent Best: #{best.fitness}")

    if problem.terminate?(best, goal) do
      best
    else
      population
      |> select(opts)
      |> crossover(opts)
      |> mutation(opts)
      |> evolve(problem, generation + 1, opts)
    end
  end

  def run(problem, opts \\ []) do
    goal = Keyword.get(opts, :goal, 100)
    population = initialize(&problem.genotype/1, goal: goal)

    population
    |> evolve(problem, 0, opts)
  end
end

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
    {ca1, goal} = solve_goal(numbers, "root")# |> IO.inspect(label: "goal")

    soln = Genetic.run(Aoc.Day21, population_size: 200, goal: goal)
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

  def solve_human(rules, monkey, chromosome) do
    # IO.inspect(monkey)
    [_, ca] = Enum.find(rules, fn [m, _] -> m == monkey end)

    case monkey do
      "root" ->
        <<ca1::binary-size(4), " + ", ca2::binary-size(4)>> = ca
        solve_human(rules, ca1, chromosome) + solve_human(rules, ca2, chromosome)

      "humn" ->
        # fitness_function(chromosome)
        chromosome

      _ ->
        case Integer.parse(ca) do
          :error ->
            case ca do
              <<ca1::binary-size(4), " + ", ca2::binary-size(4)>> ->
                solve_human(rules, ca1, chromosome) + solve_human(rules, ca2, chromosome)

              <<ca1::binary-size(4), " * ", ca2::binary-size(4)>> ->
                solve_human(rules, ca1, chromosome) * solve_human(rules, ca2, chromosome)

              <<ca1::binary-size(4), " / ", ca2::binary-size(4)>> ->
                div(solve_human(rules, ca1, chromosome), solve_human(rules, ca2, chromosome))

              <<ca1::binary-size(4), " - ", ca2::binary-size(4)>> ->
                solve_human(rules, ca1, chromosome) - solve_human(rules, ca2, chromosome)
            end

          {no, _} ->
            no
        end
    end
  end

  @behaviour Problem
  alias Types.Chromosome

  @impl true
  def genotype(goal) do
    genes = genes = for _ <- 1..13, do: Enum.random(0..9)
    %Chromosome{genes: genes, size: 13, goal: goal}
  end

  @impl true
  def fitness_function(chromosome) do
    chromosome.genes
    |> Integer.undigits()
    |> Kernel.-(chromosome.goal)
    |> Kernel.abs()
  end

  @impl true
  def terminate?(best, goal), do: best == 0
end
