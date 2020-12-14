defmodule Aoc.Day14 do
  @doc """
      iex> inp = Aoc.Day14.input("priv/day14/example.txt")
      ...> Aoc.Day14.part1(inp)
      165
  """
  def part1(inp) do
    inp
    |> Enum.reduce({%{}, []}, fn line, {memory, mask} ->
      cond do
        String.match?(line, ~r/mask = .*/) ->
          match = Regex.named_captures(~r/mask = (?<mask>.*)/, line)

          {memory, match["mask"]}
        true ->
          match = Regex.named_captures(~r/mem\[(?<adr>.*)\] = (?<val>.*)/, line)
          value = decimal_string_to_binary(match["val"])
          adr = match["adr"]
          res = mask(value, mask)

          {Map.put(memory, adr, res), mask}
      end
    end)
    |> elem(0)
    |> Enum.reduce(0, fn {_, val}, acc ->
      acc + String.to_integer(val, 2)
    end)
  end

  @doc """
      iex> Aoc.Day14.mask("000000000000000000000000000000001011", "XXXXXXXXXXXXXXXXXXXXXXXXXXXXX1XXXX0X")
      "000000000000000000000000000001001001"
  """
  def mask(value, mask) do
    mask_bits = String.graphemes(mask)

    value
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce([], fn {c, ind}, acc ->
      mask_bit = Enum.at(mask_bits, ind)

      case mask_bit do
        "X" -> [c | acc]
        _ -> [mask_bit | acc]
      end
    end)
    |> Enum.reverse()
    |> Enum.join()
  end

  @doc """
      iex> Aoc.Day14.decimal_string_to_binary("42")
      "000000000000000000000000000000101010"
  """
  def decimal_string_to_binary(decimal) do
    decimal
    |> String.to_integer()
    |> Integer.to_string(2)
    |> String.pad_leading(36, "0")
  end

  @doc """
      iex> inp = Aoc.Day14.input("priv/day14/example2.txt")
      ...> Aoc.Day14.part2(inp)
      208
  """
  def part2(inp) do
    inp
    |> Enum.reduce({%{}, []}, fn line, {memory, mask} ->
      if String.match?(line, ~r/mask = .*/) do
        match = Regex.named_captures(~r/mask = (?<mask>.*)/, line)

        {memory, match["mask"]}
      else
        match = Regex.named_captures(~r/mem\[(?<adr>.*)\] = (?<val>.*)/, line)
        val = decimal_string_to_binary(match["val"])
        adr = decimal_string_to_binary(match["adr"])
        res = mask2(adr, mask)
        res
        |> String.graphemes()
        |> Enum.count(fn c ->
          c == "X"
        end)
        |> binary_options()
        |> Enum.reduce({memory, mask}, fn opt, {memory, mask} ->
          nad =
            opt
            |> String.graphemes()
            |> Enum.reduce(res, fn c, acc ->
              String.replace(acc, "X", c, global: false)
            end)

          {Map.put(memory, nad, val), mask}
        end)
      end
    end)
    |> elem(0)
    |> Enum.reduce(0, fn {_, val}, acc ->
      acc + String.to_integer(val, 2)
    end)
  end

  @doc """
      iex> Aoc.Day14.binary_options(2)
      ["00", "01", "10", "11"]

      iex> Aoc.Day14.binary_options(3)
      ["000", "001", "010", "011", "100", "101", "110", "111"]
  """
  def binary_options(bit_count) do
    0..(Bitwise.bsl(1, bit_count) - 1)
    |> Enum.map(fn x ->
      x
      |> Integer.to_string(2)
      |> String.pad_leading(bit_count, "0")
    end)
  end

  @doc """
      iex> Aoc.Day14.mask2("000000000000000000000000000000101010", "000000000000000000000000000000X1001X")
      "000000000000000000000000000000X1101X"
  """
  def mask2(address, mask) do
    mask_bits = String.graphemes(mask)

    address
    |> String.graphemes()
    |> Enum.with_index()
    |> Enum.reduce([], fn {c, ind}, acc ->
      mask_bit = Enum.at(mask_bits, ind)

      case mask_bit do
        "0" -> [c | acc]
        "1" -> [1 | acc]
        "X" -> ["X" | acc]
      end
    end)
    |> Enum.reverse()
    |> Enum.join()
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
  end
end
