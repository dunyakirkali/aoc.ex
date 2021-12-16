defmodule Aoc.Day16 do
  @doc """
      iex> input = Aoc.Day16.input("priv/day16/example.txt")
      ...> Aoc.Day16.part1(input)
      16
  """
  def part1(input) do
    input
    |> to_bin("")
    |> parse
    |> calc(0)
  end

  @doc """
      iex> Aoc.Day16.calc({:literal, 6, 2021}, 0)
      6

      iex> Aoc.Day16.calc({:operator, 7, 3, 3, [{:literal, 2, 1}, {:literal, 6, 2}, {:literal, 1, 3}]}, 0)
      16
  """
  def calc(input, acc) when is_tuple(input) do
    calc(tl(Tuple.to_list(input)), elem(input, 1) + acc)
  end
  def calc(input, acc) when is_list(input) do
    input
    |> Enum.map(fn packet ->
      calc(packet, 0)
    end)
    |> Enum.sum
    |> Kernel.+(acc)
  end
  def calc(_, acc), do: acc

  @doc """
      iex> Aoc.Day16.parse("110100101111111000101000")
      {:literal, 6, 2021, nil}

      iex> Aoc.Day16.parse("00111000000000000110111101000101001010010001001000000000")
      {:operator, 1, 6, 27, {:literal, 6, 10, {:literal, 2, 20, nil}}, nil}

      iex> Aoc.Day16.parse("11101110000000001101010000001100100000100011000001100000")
      {:operator, 7, 3, 3, {:literal, 2, 1, {:literal, 4, 2, {:literal, 1, 3, nil}}}}
  """
  def parse(<<version::binary-size(3), "100", rest::binary>>) do
    {val, rem} = literal(rest, "")
    {
      :literal,
      String.to_integer(version, 2),
      val,
      parse(rem)
    }
  end

  def parse(<<version::binary-size(3), type_id::binary-size(3), "0", total_length::binary-size(15), rest::binary>>) do
    bin_len = String.to_integer(total_length, 2)

    <<subpackets::binary-size(bin_len), rest::binary>> = rest
    {
      :operator,
      String.to_integer(version, 2),
      String.to_integer(type_id, 2),
      bin_len,
      parse(subpackets),
      parse(rest)
    }
  end

  def parse(<<version::binary-size(3), type_id::binary-size(3), "1", number_of_subpackets::binary-size(11), rest::binary>>) do
    # IO.inspect(rest)
    {
      :operator,
      String.to_integer(version, 2),
      String.to_integer(type_id, 2),
      String.to_integer(number_of_subpackets, 2),
      parse(rest)
    }
  end

  def parse(_) do
  end
  @doc """
      iex> Aoc.Day16.literal("00001", "")
      {1, ""}

      iex> Aoc.Day16.literal("00010", "")
      {2, ""}

      iex> Aoc.Day16.literal("00011", "")
      {3, ""}

      iex> Aoc.Day16.literal("101111111000101", "")
      {2021, ""}

      iex> Aoc.Day16.literal("01010", "")
      {10, ""}

      iex> Aoc.Day16.literal("1000100100", "")
      {20, ""}
  """
  def literal(<<"1", chunk::binary-size(4), rest::binary>>, acc) do
    literal(rest, acc <> chunk)
  end
  def literal(<<"0", chunk::binary-size(4), rest::binary>>, acc) do
    {String.to_integer(acc <> chunk, 2), rest}
  end

  @doc """
      iex> input = Aoc.Day16.input("priv/day16/example.txt")
      ...> Aoc.Day16.to_bin(input, "")
      "100010100000000001001010100000000001101010000000000000101111010001111000"
  """
  def to_bin([], acc), do: acc

  def to_bin([h | t], acc) do
    map =
      case h do
        "0" -> "0000"
        "1" -> "0001"
        "2" -> "0010"
        "3" -> "0011"
        "4" -> "0100"
        "5" -> "0101"
        "6" -> "0110"
        "7" -> "0111"
        "8" -> "1000"
        "9" -> "1001"
        "A" -> "1010"
        "B" -> "1011"
        "C" -> "1100"
        "D" -> "1101"
        "E" -> "1110"
        "F" -> "1111"
      end

    to_bin(t, acc <> map)
  end

  @doc """
      iex> Aoc.Day16.part2("C200B40A82")
      3

      # iex> Aoc.Day16.part2("04005AC33890")
      # 54

      # iex> Aoc.Day16.part2("880086C3E88112")
      # 7

      # iex> Aoc.Day16.part2("CE00C43D881120")
      # 9

      # iex> Aoc.Day16.part2("D8005AC2A8F0")
      # 1

      # iex> Aoc.Day16.part2("F600BC2D8F")
      # 0

      # iex> Aoc.Day16.part2("9C005AC2F8F0")
      # 0

      # iex> Aoc.Day16.part2("9C0141080250320F1802104A08")
      # 1
  """
  def part2(input) when is_binary(input) do
    input
    |> String.graphemes()
    |> part2
  end

  def part2(input) do
    input
    |> to_bin("")
    |> parse
    |> IO.inspect()
    |> reduce()
  end

  def reduce({:literal, _, val, nil}), do: val
  def reduce({:literal, _, val, data}), do: reduce(data)
  def reduce(tuple) do
    data = tuple |> Tuple.to_list |> List.last()
    case elem(tuple, 0) do
      :operator ->
        case elem(tuple, 2) do
          0 ->
            reduce(data)
          1 ->
            IO.puts("*")
          2 ->
            IO.puts("min")
          3 ->
            IO.puts("max")

          5 ->
            IO.puts(">")
          6 ->
            IO.puts("<")
          7 ->
            IO.puts("==")
        end
    end
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.graphemes()
  end
end
