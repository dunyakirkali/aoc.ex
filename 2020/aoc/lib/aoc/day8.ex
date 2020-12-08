defmodule Aoc.Day8 do
  @doc """
      iex> inp = Aoc.Day8.input("priv/day8/example.txt")
      ...> Aoc.Day8.part1(inp)
      5
  """
  def part1(inp) do
    inp
    |> Enum.map(fn row ->
      [action, value] = String.split(row, " ", trim: true)
      [action, String.to_integer(value)]
    end)
    |> Enum.with_index()
    |> run([], 0, 0)
  end

  def run(instructions, history, cursor, acc) do
    if Enum.member?(history, cursor) do
      acc
    else
      instruction = Enum.at(instructions, cursor)

      {new_index, acc} =
        case instruction do
          {["nop", _], index} ->
            {index + 1, acc}

          {["jmp", amount], index} ->
            {index + amount, acc}

          {["acc", amount], index} ->
            {index + 1, acc + amount}
        end

      run(instructions, [cursor | history], new_index, acc)
    end
  end

  def calc(amount, acc) do
    amount
    |> Kernel.+(acc)
  end

  @doc """
      iex> inp = Aoc.Day8.input("priv/day8/example.txt")
      ...> Aoc.Day8.part2(inp)
      8
  """
  def part2(inp) do
    inp
    |> Enum.map(fn row ->
      [action, value] = String.split(row, " ", trim: true)
      [action, String.to_integer(value)]
    end)
    |> Enum.with_index()
    |> run2([], 0, 0, 0)
  end

  def run2(instructions, history, cursor, acc, to_mut) do
    if cursor == Enum.count(instructions) do
      acc
    else
      if Enum.member?(history, cursor) do
        run2(instructions, [], 0, 0, to_mut + 1)
      else
        instruction = Enum.at(instructions, cursor)

        {new_cursor, acc} =
          case instruction do
            {["nop", amount], index} ->
              if to_mut == cursor do
                {index + amount, acc}
              else
                {index + 1, acc}
              end

            {["jmp", amount], index} ->
              if to_mut == cursor do
                {index + 1, acc}
              else
                {index + amount, acc}
              end

            {["acc", amount], index} ->
              {index + 1, acc + amount}
          end

        run2(instructions, [cursor | history], new_cursor, acc, to_mut)
      end
    end
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
