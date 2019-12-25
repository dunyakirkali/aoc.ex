defmodule Aoc.Day25 do
  def part1() do
    droid = AGC.new("priv/day25/input.txt")
    program = """
    south
    take food ration
    west
    north
    north
    east
    take astrolabe
    west
    south
    south
    east
    north
    east
    take cake
    south
    take weather machine
    west
    take ornament
    west
    take jam
    east
    east
    north
    east
    east
    east
    drop food ration
    drop astrolabe
    drop cake
    drop jam
    drop weather machine
    drop ornament
    """

    options =
      ["jam", "astrolabe", "ornament", "weather machine", "food ration", "cake"]
      |> Comb.subsets()
      |> Enum.to_list

    droid = run(droid, program)

    solve(droid, options)
    |> Map.get(:output)
    |> IO.puts
  end


  def solve(droid, []), do: droid
  def solve(droid, [option | rest]) do
    IO.puts(Enum.join(option, ", "))
    take_command =
      option
      |> Enum.reduce("", fn item, acc ->
        acc <> "take " <> item <> "\n"
      end)
    take_command = take_command <> "south\n"

    drop_command =
      option
      |> Enum.reduce("", fn item, acc ->
        acc <> "drop " <> item <> "\n"
      end)


    droid =
      droid
      |> Map.put(:inputs, transform(take_command <> drop_command))
      |> AGC.run()

    question = droid.output

    IO.puts(question)

    droid =
      droid
      |> Map.put(:output, [])

    if droid.state == :halt do
      droid
    else
      solve(droid, rest)
    end
  end

  def run(droid, input \\ "") do
    droid =
      droid
      |> Map.put(:inputs, transform(input))
      |> AGC.run()

    question = droid.output

    IO.puts(question)

    droid =
      droid
      |> Map.put(:output, [])

    # answer = IO.gets question

    # run(droid, answer)
  end

  def transform(command) do
    command
    |> String.graphemes
    |> Enum.map(fn x ->
      x
      |> String.to_charlist
      |> hd
    end)
  end
end
