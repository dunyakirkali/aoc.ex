defmodule Day9 do
  @moduledoc """
  Documentation for Day9.
  """

  @doc """
      iex> Day9.part_2("(3x3)XYZ")
      9
      
      iex> Day9.part_2("X(8x2)(3x3)ABCY")
      20
      
      iex> Day9.part_2("(27x12)(20x12)(13x14)(7x10)(1x12)A")
      241920
      
      iex> Day9.part_2("(25x3)(3x3)ABC(2x3)XY(5x2)PQRSTX(18x9)(3x2)TWO(5x7)SEVEN")
      445
  """  
  def part_2(string) do
    decompress(string)
  end
  
  defp decompress(raw, count \\ 0)

  defp decompress("", count), do: count

  defp decompress(<<"(", rest::binary>>, count) do
    IO.puts("remaining: #{String.length(rest)}")
    [counts, rest] = String.split(rest, ")", parts: 2)
    [num, times] =
      counts
      |> String.split("x")
      |> Enum.map(&String.to_integer/1)
    {compressed, rest} = String.split_at(rest, num)

    decompress(String.duplicate(compressed, times) <> rest, count)
  end

  defp decompress(<<_::binary-size(1), rest::binary>>, count) do
    decompress(rest, count + 1)
  end
  
  defp weights(string) do
    for _ <- 0..(String.length(string) - 1), do: 1
  end
  
  @doc """
      iex> Day9.part_1("ADVENT")
      6
  
      iex> Day9.part_1("A(1x5)BC")
      7
  
      iex> Day9.part_1("(3x3)XYZ")
      9
  
      iex> Day9.part_1("A(2x2)BCD(2x2)EFG")
      11
  
      iex> Day9.part_1("(6x1)(1x3)A")
      6
  
      iex> Day9.part_1("X(8x2)(3x3)ABCY")
      18
  """
  def part_1(string) do
    string
    |> Day9.expand()
    |> String.length()
  end
  
  @doc """
      iex> Day9.expand("ADVENT")
      "ADVENT"
      
      iex> Day9.expand("A(1x5)BC")
      "ABBBBBC"
      
      iex> Day9.expand("(3x3)XYZ")
      "XYZXYZXYZ"
      
      iex> Day9.expand("A(2x2)BCD(2x2)EFG")
      "ABCBCDEFEFG"
      
      iex> Day9.expand("(6x1)(1x3)A")
      "(1x3)A"
      
      iex> Day9.expand("X(8x2)(3x3)ABCY")
      "X(3x3)ABC(3x3)ABCY"
  """  
  def expand(string) do
    string
    |> String.graphemes()
    |> Day9.expand([])
    |> Enum.reverse()
    |> Enum.join("")
  end
  
  def expand([head | tail], acc) do
    case head do
      "(" -> expand_marker(tail, acc)
      _ -> expand(tail, [head | acc])
    end
  end
  def expand([], acc), do: acc
  
  def expand_marker(string, acc) do
    marker =
      string
      |> Enum.take_while(fn x -> x != ")" end)
      |> Enum.join()

    [_ | t] = String.split(Enum.join(string), marker <> ")")
    rest = Enum.join(t, marker <> ")")
    
    [char_count, times] =
      marker
      |> String.split("x")
      |> Enum.map(&(String.to_integer(&1)))
    
    {chars, rest} =
      rest
      |> String.split_at(char_count)
    
    acc =
      0..(times - 1)
      |> Enum.reduce(acc, fn _, acc ->
        [chars | acc]
      end)
    
    expand(String.graphemes(rest), acc)
  end
end
