defmodule Day5 do
  @moduledoc """
  Documentation for Day5.
  """
  
  @doc """
      iex> Day5.part_2("abc")
      "05ace8e3"
  """
  def part_2(door_id) do
    find_pass_2(door_id, 0, "________")
  end
  
  def find_pass_2(str, inc, acc) do
    if acc |> String.codepoints |> Enum.filter(fn x -> x != "_" end) |> Enum.count == 8 do
      acc
    else
      test_str = "#{str}#{inc}"
      md5 = :crypto.hash(:md5, test_str) |> Base.encode16(case: :lower)

      if Regex.match?(~r/^00000.+$/, md5) do
        poss = String.at(md5, 5)
        char = String.at(md5, 6)
        
        if Enum.member?(["0", "1", "2", "3", "4", "5", "6", "7"], poss) do
          poss_it = String.to_integer(poss)
          if String.at(acc, poss_it) == "_" do
            acc = acc |> String.codepoints |> List.replace_at(poss_it, char) |> Enum.join("")
            find_pass_2(str, inc + 1, acc)
          else
            find_pass_2(str, inc + 1, acc)
          end
        else
          find_pass_2(str, inc + 1, acc)
        end
      else
        find_pass_2(str, inc + 1, acc)
      end
    end
  end

  @doc """
      iex> Day5.part_1("abc")
      "18f47a30"
  """
  def part_1(door_id) do
    find_pass(door_id, 0, "")
  end
  
  def find_pass(str, inc, acc) do
    if String.length(acc) == 8 do
      acc
    else
      test_str = "#{str}#{inc}"
      md5 = :crypto.hash(:md5, test_str) |> Base.encode16(case: :lower)
  
      if Regex.match?(~r/^00000.+$/, md5) do
        pass = String.at(md5, 5)
        find_pass(str, inc + 1, acc <> pass)
      else
        find_pass(str, inc + 1, acc)
      end
    end
  end
end
