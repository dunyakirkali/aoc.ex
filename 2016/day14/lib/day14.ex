defmodule Day14 do
  use Memoize
  
  @keys_required 64
  
  @doc """
      iex> Day14.part_2("abc")
      22551
  """
  def part_2(salt) do
    0..999_999_999
    |> Enum.reduce_while(0, fn index, key_count ->
      if key?(salt, index, true) do
        key_count = key_count + 1
        IO.puts("Found #{key_count}nth")
        if key_count == @keys_required do
          {:halt, index}
        else
          {:cont, key_count}
        end
      else
        {:cont, key_count}
      end
    end)
  end

  @doc """
      iex> Day14.part_1("abc")
      22728
  """
  def part_1(salt) do
    0..999_999_999
    |> Enum.reduce_while(0, fn index, key_count ->
      if key?(salt, index) do
        key_count = key_count + 1
        IO.puts("Found #{key_count}nth")
        if key_count == @keys_required do
          {:halt, index}
        else
          {:cont, key_count}
        end
      else
        {:cont, key_count}
      end
    end)
  end
  
  @doc """
      iex> Day14.hash("abc", 18)
      "0034e0923cc38887a57bd7b1d4f953df"
  
      iex> Day14.hash("abc", 39)
      "347dac6ee8eeea4652c7476d0f97bee5"
  """
  defmemo hash(salt, index) do
    :crypto.hash(:md5, "#{salt}#{index}") |> Base.encode16(case: :lower)
  end
  
  @doc """
      iex> Day14.streched_hash("abc", 0)
      "a107ff634856bb300138cac6568c0f24"
  """
  defmemo streched_hash(salt, index) do
    1..2016
    |> Enum.reduce(hash(salt, index), fn _, acc ->
      :crypto.hash(:md5, acc) |> Base.encode16(case: :lower)
    end)
  end
  
  @doc """
      iex> Day14.key?("abc", 18)
      false
      
      iex> Day14.key?("abc", 39)
      true
  """
  defmemo key?(salt, index, streched \\ false) do
    case repeated?(salt, index, 3, streched) do
      false -> false
      match ->
        filtered =
          (index + 1)..(index + 1000)
          |> Enum.filter(fn i ->
            case repeated?(salt, i, 5, streched) do
              false -> false
              h ->
                List.first(String.graphemes(h)) == List.first(String.graphemes(match))
            end
          end)
        length(filtered) != 0
    end
  end
  
  @doc """
      iex> Day14.repeated?("abc", 18, 3)
      "888"
  
      iex> Day14.repeated?("abc", 0, 3)
      false
  """
  defmemo repeated?(salt, index, count, streched \\ false) do
    if streched do
      case Regex.run(~r/((\w)\2{#{count - 1},})/, streched_hash(salt, index)) do
        nil -> false
        [h | t] -> h
      end
    else
      case Regex.run(~r/((\w)\2{#{count - 1},})/, hash(salt, index)) do
        nil -> false
        [h | t] -> h
      end
    end
  end
end
