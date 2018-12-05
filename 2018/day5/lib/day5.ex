defmodule Day5 do
  def part2(polymer) do
    Enum.reduce(?a..?z, [], fn x, acc ->
      len = clean(polymer, List.to_string([x]))
      |> react
      |> String.length
      [len | acc]
    end)
    |> Enum.min
  end

  def clean(polymer, char) do
    Regex.replace(~r/[#{char}|#{String.upcase(char)}]/, polymer, "")
  end

  def react(polymer) do
    poly_list = polymer |> String.trim |> String.split("")
    Enum.reduce_while(0..100_000_000_000_000, poly_list, fn _, acc ->
      if acc == iterate(acc) do
        {:halt, acc}
      else
        {:cont, iterate(acc)}
      end
    end)
    |> Enum.join()
  end

  defp iterate(poly_list) do
    poly_list
    |> implode()
  end

  defp implode([head | tail]) do
    if swapcase(head) == Enum.at(tail, 0) do
      tail
      |> List.delete_at(0)
      |> implode()
    else
      [head | implode(tail)]
    end
  end

  defp implode([]) do
    []
  end

  defp swapcase(char) do
    if char =~ ~r/^\p{Lu}$/u,
      do: String.downcase(char),
      else: String.upcase(char)
  end
end
