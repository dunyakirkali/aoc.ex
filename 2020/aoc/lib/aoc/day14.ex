defmodule Aoc.Day14 do
  @doc """
      iex> inp = Aoc.Day14.input("priv/day14/example.txt")
      ...> Aoc.Day14.part1(inp)
      165
  """
  def part1(inp) do
    memory = %{}

    {memory, mask} =
      inp
      |> Enum.reduce({memory, []}, fn line, {memory, mask} ->
        if String.match?(line, ~r/mask = .*/) do
          match = Regex.named_captures(~r/mask = (?<mask>.*)/, line)

          {memory, match["mask"]}
        else
          match = Regex.named_captures(~r/mem\[(?<adr>.*)\] = (?<val>.*)/, line)

          val =
            match["val"]
            |> String.to_integer()
            |> Integer.to_string(2)
            |> String.pad_leading(36, "0")

          adr = match["adr"]

          maske = String.graphemes(mask)

          res =
            val
            |> String.graphemes()
            |> Enum.with_index()
            |> Enum.reduce([], fn {c, ind}, acc ->
              maskb = Enum.at(maske, ind)

              if maskb != "X" do
                [maskb | acc]
              else
                [c | acc]
              end
            end)
            |> Enum.reverse()
            |> Enum.join()

          {Map.put(memory, adr, res), mask}
        end
      end)

    memory
    |> Enum.reduce(0, fn {adr, val}, acc ->
      acc + String.to_integer(val, 2)
    end)
  end

  @doc """
      iex> inp = Aoc.Day14.input("priv/day14/example2.txt")
      ...> Aoc.Day14.part2(inp)
      208
  """
  def part2(inp) do
    memory = %{}

    {memory, mask} =
      inp
      |> Enum.reduce({memory, []}, fn line, {memory, mask} ->
        if String.match?(line, ~r/mask = .*/) do
          # |> IO.inspect(label: "A")
          match =
            Regex.named_captures(~r/mask = (?<mask>.*)/, line)
            # |> IO.inspect(label: "MASK")

          {memory, match["mask"]}
        else
          # |> IO.inspect(label: "B")
          match = Regex.named_captures(~r/mem\[(?<adr>.*)\] = (?<val>.*)/, line)
          # |> IO.inspect(label: "bin")
          val =
            match["val"]
            |> String.to_integer()
            |> Integer.to_string(2)
            |> String.pad_leading(36, "0")

          adr = match["adr"]# |> IO.inspect(label: "Ad")
          # memory |> IO.inspect(label: "mem")
          maske = String.graphemes(mask)

          res =
            adr
            |> String.to_integer()
            |> Integer.to_string(2)
            |> String.pad_leading(36, "0")
            # |> IO.inspect(label: "adb")
            |> String.graphemes()
            |> Enum.with_index()
            |> Enum.reduce([], fn {c, ind}, acc ->
              maskb = Enum.at(maske, ind)

              case maskb do
                "0" -> [c | acc]
                "1" -> [1 | acc]
                "X" -> ["X" | acc]
              end
            end)
            |> Enum.reverse()
            |> Enum.join()

          # |> IO.inspect(label: "mmm")

          # |> IO.inspect(label: "X")
          xc = res |> String.graphemes() |> Enum.count(fn c -> c == "X" end)

          opts =
            0..(Bitwise.bsl(1, xc) - 1)
            |> Enum.map(fn x -> x |> Integer.to_string(2) |> String.pad_leading(xc, "0") end)

          # IO.inspect(mask, label: "mask")
          opts
          # |> IO.inspect()
          |> Enum.reduce({memory, mask}, fn opt, {memory, mask} ->
            nad =
              opt
              |> String.graphemes()
              |> Enum.reduce(res, fn c, acc ->
                String.replace(acc, "X", c, global: false)
              end)

            # IO.inspect("Put #{val} to #{nad}")
            {Map.put(memory, nad |> String.to_integer(2), val), mask}
          end)
        end
      end)

    memory
    |> Enum.reduce(0, fn {adr, val}, acc ->
      acc + String.to_integer(val, 2)
    end)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
