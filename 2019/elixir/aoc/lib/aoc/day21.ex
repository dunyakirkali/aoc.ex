defmodule Aoc.Day21 do
  defmodule Springdroid do
    defstruct [
      :brain,
      registers: %{
        j: false,
        t: false,
        a: nil,
        b: nil,
        c: nil,
        d: nil,
        e: nil,
        f: nil,
        g: nil,
        h: nil,
        i: nil
      }
    ]
  end

  def part1() do
    program = """
    NOT A J
    NOT B T
    OR T J
    NOT C T
    OR T J
    AND D J
    WALK
    """
    brain = AGC.new("priv/day21/input.txt")
    droid = %Springdroid{brain: brain}
    |> run(program)
    |> Map.get(:brain)
    |> Map.get(:output)
    |> List.last
  end

  def part2() do
    program = """
    NOT A J
    NOT B T
    OR T J
    NOT C T
    OR T J
    AND D J
    NOT E T
    NOT T T
    OR H T
    AND T J
    RUN
    """
    brain = AGC.new("priv/day21/input.txt")
    droid = %Springdroid{brain: brain}
    |> run(program)
    |> Map.get(:brain)
    |> Map.get(:output)
    |> List.last
  end

  def dand(droid, x, y) do
    if read(droid, x) and read(droid, y) do
      write(droid, y, true)
    else
      write(droid, y, false)
    end
  end

  def dor(droid, x, y) do
    if read(droid, x) or read(droid, y) do
      write(droid, y, true)
    else
      write(droid, y, false)
    end
  end

  def dnot(droid, x, y) do
    if read(droid, x) == false do
      write(droid, y, true)
    else
      write(droid, y, false)
    end
  end

  def read(droid, register) do
    Map.get(droid.registers, register)
  end

  def write(droid, register, value) do
    %Springdroid{droid | registers: Map.put(droid.registers, register, value)}
  end

  def run(droid, program) do
    input =
      program
      |> String.graphemes
      |> Enum.map(fn x ->
        x
        |> String.to_charlist
        |> hd
      end)

    brain =
      droid.brain
      |> Map.put(:inputs, input)
      |> AGC.run()

    %Springdroid{droid | brain: brain}
  end
end
