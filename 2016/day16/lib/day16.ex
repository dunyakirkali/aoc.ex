defmodule Day16 do
  def part_2(str) do
    str
    |> fill_up(35651584)
    |> checksum_while_even()
  end
  
  def part_1(str) do
    str
    |> fill_up(272)
    |> checksum_while_even()
  end
  
  @doc """
      iex> Day16.checksum_while_even("110010110100")
      "100"
  """
  def checksum_while_even(str) do
    if rem(String.length(str), 2) == 0 do
      checksum_while_even(checksum(str))
    else
      str
    end
  end
  
  @doc """
      iex> Day16.checksum("10000011110010000111")
      "0111110101"
      
      iex> Day16.checksum("110010110100")
      "110101"
  """
  def checksum(str) do
    str
    |> String.graphemes()
    |> Enum.chunk_every(2)
    |> Enum.map(fn [l, r] ->
      if l == r do
        "1"
      else
        "0"
      end
    end)
    |> Enum.join("")
  end
  
  @doc """
      iex> Day16.fill_up("10000")
      "10000011110010000111"
  """
  def fill_up(str, len \\ 20) do
    if String.length(str) < len do
      fill_up(fill(str), len)
     else
       String.slice(str, 0..(len - 1))
    end
  end
  
  @doc """
      iex> Day16.fill("1")
      "100"
      
      iex> Day16.fill("0")
      "001"
      
      iex> Day16.fill("11111")
      "11111000000"
      
      iex> Day16.fill("111100001010")
      "1111000010100101011110000"
  """
  def fill(a) do
    b =
      a
      |> String.reverse()
      |> String.graphemes()
      |> Enum.map(fn char ->
        case char do
          "0" -> "1"
          "1" -> "0"
        end
      end)
      |> Enum.join("")

    a <> "0" <> b
  end
end
