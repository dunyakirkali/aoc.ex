defmodule M do
  def esc_length(char_list), do: esc_length(char_list, -2)
  def esc_length([], acc), do: acc
  def esc_length([?\\ , ?\\ | t], acc), do: esc_length(t, acc + 1)
  def esc_length([?\\ , ?x , _ , _ | t], acc), do: esc_length(t, acc + 1)
  def esc_length([?\\ , ?" | t], acc), do: esc_length(t, acc + 1)
  def esc_length([_ | t], acc), do: esc_length(t, acc + 1)
end

'./day8/input.txt'
  |> File.read!
  |> String.split("\n", trim: true)
  |> Enum.map(fn(str) ->
    
    String.length(str) - M.esc_length(String.to_charlist(str))
  end)
  |> Enum.sum
  |> IO.inspect
