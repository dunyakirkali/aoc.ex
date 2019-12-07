defmodule Aoc.Day7 do
  @doc """
      # iex> Aoc.Day7.part1("priv/day7/example_1.txt")
      # 43210

      # iex> Aoc.Day7.part1("priv/day7/example_2.txt")
      # 54321
      #
      # iex> Aoc.Day7.part1("priv/day7/example_3.txt")
      # 65210
  """
  def part1(filename) do
    0..4
    |> Combination.permutate
    |> Enum.map(fn option ->
      Enum.reduce(0..4, 0, fn i, signal ->
        filename
        |> AGC.new()
        |> Map.put(:inputs, [Enum.at(option, i), signal])
        |> AGC.run()
        |> Map.get(:output)
      end)
    end)
    |> Enum.max
  end

  def part2(filename) do
    machines =
      0..4
      |> Enum.map(fn _ ->
        AGC.new(filename)
      end)

    5..9
    |> Combination.permutate
    |> Enum.map(fn option ->
      Stream.iterate(0, &(&1 + 1))
      |> Enum.reduce_while(machines, fn i, machines ->
        index = rem(i, 5)
        pindex =
          if index == 0 do
            4
          else
            index - 1
          end

        inputs =
          if i == 0 do
            [Enum.at(option, index), 0]
          else
            pm = Enum.at(machines, pindex)
            if i < 5 do
              [Enum.at(option, index), pm.output]
            else
              [pm.output]
            end
          end
          |> Enum.filter(fn x ->
            x !=nil
          end)
        machine =
          machines
          |> Enum.at(index)
          |> Map.put(:inputs, inputs)
          |> AGC.run()

        machines = List.replace_at(machines, index, machine)
        done =
          machines
          |> Enum.filter(fn machine ->
            machine.state == :halt
          end)
          |> Enum.count
          |> Kernel.==(5)
        if done do
          {:halt, machines}
        else
          {:cont, machines}
        end
      end)
      |> Enum.at(4)
    end)
    |> Enum.map(fn m ->
      m.output
    end)
    |> Enum.max
  end
end
