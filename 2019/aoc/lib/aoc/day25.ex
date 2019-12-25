defmodule Aoc.Day25 do
  def part1() do
    droid = AGC.new("priv/day25/input.txt")
    run(droid)
  end

  def run(droid, input \\ "") do
    droid =
      droid
      |> Map.put(:input, transform(input))
      |> AGC.run()

    question = Map.get(droid, :output)

    answer = IO.gets question

    run(droid, answer)
  end

  def transform(command) do
    command
    |> String.graphemes
    |> Enum.map(fn x ->
      x
      |> String.to_charlist
      |> hd
      |> IO.inspect
    end)
  end
end
