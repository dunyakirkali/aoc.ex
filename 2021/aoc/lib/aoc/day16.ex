defmodule Aoc.Day16 do
  @doc """
      iex> Aoc.Day16.part1("8A004A801A8002F478")
      16
  """
  def part1(input) do
    input
    |> Base.decode16!()
    |> parse()
    |> solve1()
  end

  def parse(data) do
    {data, %{}}
    |> parse_meta(:version)
    |> parse_meta(:type)
    |> parse_by_type()
  end

  def parse_meta({<<meta_value::3, rest::bitstring>>, meta}, meta_key) do
    {rest, Map.put(meta, meta_key, meta_value)}
  end

  def parse_by_type({data, %{type: 4} = meta}) do
    {literal, rest} = parse_literal(data)
    {{bits_to_int(literal), rest}, meta}
  end

  def parse_by_type({data, meta}) do
    {parse_operator(data), meta}
  end

  def parse_literal(<<1::1, n::4, rest::bitstring>>) do
    {data, rest} = parse_literal(rest)
    {<<n::4, data::bitstring>>, rest}
  end

  def parse_literal(<<0::1, n::4, rest::bitstring>>) do
    {<<n::4>>, rest}
  end

  def parse_operator(<<0::1, length::15, rest::bitstring>>) do
    <<payload::bitstring-size(length), rest::bitstring>> = rest
    {parse_sub(payload), rest}
  end

  def parse_operator(<<1::1, length::11, rest::bitstring>>) do
    {data, [rest]} = Enum.split(parse_sub(rest, length), -1)
    {data, rest}
  end

  def parse_sub(<<>>), do: []

  def parse_sub(data) do
    {{data, rest}, meta} = parse(data)
    [{{data, []}, meta} | parse_sub(rest)]
  end

  def parse_sub(rest, 0), do: [rest]

  def parse_sub(data, n) do
    {{data, rest}, meta} = parse(data)
    [{{data, []}, meta} | parse_sub(rest, n - 1)]
  end

  def solve1({{data, _rest}, meta}) when is_list(data) do
    meta.version + (data |> Enum.map(&solve1/1) |> Enum.sum())
  end

  def solve1({{_data, _rest}, meta}) do
    meta.version
  end

  def solve2({{data, _}, %{type: 0}}) do
    data |> Enum.map(&solve2/1) |> Enum.sum()
  end

  def solve2({{data, _}, %{type: 1}}) do
    data |> Enum.map(&solve2/1) |> Enum.product()
  end

  def solve2({{data, _}, %{type: 2}}) do
    data |> Enum.map(&solve2/1) |> Enum.min()
  end

  def solve2({{data, _}, %{type: 3}}) do
    data |> Enum.map(&solve2/1) |> Enum.max()
  end

  def solve2({{data, _}, %{type: 4}}) do
    data
  end

  def solve2({{data, _}, %{type: 5}}) do
    data
    |> Enum.map(&solve2/1)
    |> then(fn [a, b] -> (a > b && 1) || 0 end)
  end

  def solve2({{data, _}, %{type: 6}}) do
    data
    |> Enum.map(&solve2/1)
    |> then(fn [a, b] -> (a < b && 1) || 0 end)
  end

  def solve2({{data, _}, %{type: 7}}) do
    data
    |> Enum.map(&solve2/1)
    |> then(fn [a, b] -> (a == b && 1) || 0 end)
  end

  defp bits_to_int(bits) do
    s = bit_size(bits)
    <<int::size(s)>> = bits
    int
  end

  @doc """
      iex> Aoc.Day16.part2("C200B40A82")
      3

      iex> Aoc.Day16.part2("04005AC33890")
      54

      iex> Aoc.Day16.part2("880086C3E88112")
      7

      iex> Aoc.Day16.part2("CE00C43D881120")
      9

      iex> Aoc.Day16.part2("D8005AC2A8F0")
      1

      iex> Aoc.Day16.part2("F600BC2D8F")
      0

      iex> Aoc.Day16.part2("9C005AC2F8F0")
      0

      iex> Aoc.Day16.part2("9C0141080250320F1802104A08")
      1
  """
  def part2(input) when is_binary(input) do
    input
    |> :binary.decode_hex()
    |> parse()
    |> solve2()
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.trim()
  end
end
