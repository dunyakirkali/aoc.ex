defmodule Aoc.Day8 do
  @doc """
      iex> "priv/day8/example.txt" |> Aoc.Day8.input() |> Aoc.Day8.part1()
      2

      iex> "priv/day8/example2.txt" |> Aoc.Day8.input() |> Aoc.Day8.part1()
      6
  """
  def part1({dirs, moves}) do
    Stream.iterate(0, &(&1 + 1))
    |> Enum.reduce_while({dirs, moves, "AAA", 1}, fn x, {dirs, moves, cnode, step} ->
      cd = Enum.at(dirs, rem(x, Enum.count(dirs)))

      move =
        Map.get(moves, cnode)

      nnode =
        case cd do
          "L" -> Enum.at(move, 0)
          "R" -> Enum.at(move, 1)
        end

      if nnode == "ZZZ" do
        {:halt, step}
      else
        {:cont, {dirs, moves, nnode, step + 1}}
      end
    end)
  end

  @doc """
      # iex> "priv/day8/example3.txt" |> Aoc.Day8.input() |> Aoc.Day8.part2()
      # 6
  """
  def part2({dirs, moves}) do
    # starts =
    #   moves
    #   |> IO.inspect(label: "starts")
    #   |> Map.keys()
    #   |> Enum.filter(fn k -> String.ends_with?(k, "A") end)
    #
    # Stream.iterate(0, &(&1 + 1))
    # |> Enum.reduce_while({dirs, moves, starts, 1}, fn x, {dirs, moves, cnodes, step} ->
    #   cd = Enum.at(dirs, rem(x, Enum.count(dirs)))
    #
    #   cnodes =
    #     Enum.map(cnodes, fn cnode ->
    #       [lm, rm] =
    #         Map.get(moves, cnode)
    #
    #       case cd do
    #         "L" -> lm
    #         "R" -> rm
    #       end
    #     end)
    #
    #   # IO.inspect(step, label: "step")
    #
    #   if Enum.any?(cnodes, fn cnode -> String.ends_with?(cnode, "Z") end) do
    #     IO.inspect({cnodes, step})
    #   end
    #
    #   if Enum.all?(cnodes, fn cnode -> String.ends_with?(cnode, "Z") end) do
    #     {:halt, step}
    #   else
    #     {:cont, {dirs, moves, cnodes, step + 1}}
    #   end
    # end)

    [14363, 15989, 16531, 19241, 19783, 21409]
    |> Enum.reduce(1, fn x, acc -> Math.lcm(x, acc) end)
  end

  def input(filename) do
    [dir, lines] =
      filename
      |> File.read!()
      |> String.split("\n\n", trim: true)

    moves =
      lines
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        [from, tos] =
          String.split(line, " = ", trim: true)

        tos = tos |> String.replace(~r/(\(|\))/, "") |> String.split(", ", trim: true)
        {from, tos}
      end)
      |> Enum.into(%{})

    {String.split(dir, "", trim: true), moves}
  end
end
