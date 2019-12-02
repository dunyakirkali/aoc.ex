defmodule Aoc.Day2 do

  @doc """
      iex> Aoc.Day2.part1([1,0,0,0,99])
      [2,0,0,0,99]

      iex> Aoc.Day2.part1([2,3,0,3,99])
      [2,3,0,6,99]

      iex> Aoc.Day2.part1([2,4,4,5,99,0])
      [2,4,4,5,99,9801]

      iex> Aoc.Day2.part1([1,1,1,4,99,5,6,0,99])
      [30,1,1,4,2,5,6,0,99]
  """
  def part1(list) do
    parse_line(list, 0)
  end

  defp parse_line(list, index) do
    line = Enum.slice(list, index, 4)
    case line do
      [opcode, ini1, ini2, outi] ->
        case opcode do
          1 ->
            list
            |> add(ini1, ini2, outi)
            |> parse_line(index + 4)
          2 ->
            list
            |> mul(ini1, ini2, outi)
            |> parse_line(index + 4)
          _ ->
            list
        end
      _ ->
        list
    end
  end

  defp mul(list, ini1, ini2, outi) do
    in1 = Enum.at(list, ini1)
    in2 = Enum.at(list, ini2)
    sum = in1 * in2
    List.replace_at(list, outi, sum)
  end

  defp add(list, ini1, ini2, outi) do
    in1 = Enum.at(list, ini1)
    in2 = Enum.at(list, ini2)
    sum = in1 + in2
    List.replace_at(list, outi, sum)
  end

  def part2(goal) do
    list = Aoc.Day2.input
    {noun, verb} =
      for(noun <- 0..99, verb <- 0..99, do: {noun, verb})
      |> Enum.find(fn {noun, verb} ->
        list
        |> List.replace_at(1, noun)
        |> List.replace_at(2, verb)
        |> Aoc.Day2.part1()
        |> Enum.at(0)
        |> Kernel.==(goal)
      end)
    100 * noun + verb
  end

  def input() do
    "priv/day2/input.txt"
    |> File.read!()
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(fn x ->
      String.to_integer(x)
    end)
  end
end
