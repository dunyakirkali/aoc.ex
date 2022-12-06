defmodule Aoc.Day5 do
  def part1({map, actions}) do
    actions
    |> Enum.reduce(map, fn {amount, from, to}, acc ->
      picked =
        acc
        |> Map.get(from)
        |> Enum.take(amount)

      acc
      |> Map.put(from, Map.get(acc, from) -- picked)
      |> Map.put(to, Enum.reverse(picked) ++ Map.get(acc, to))
    end)
    |> Enum.map(fn {_, v} ->
      List.first(v)
    end)
    |> Enum.join()
  end

  def part2({map, actions}) do
    actions
    |> Enum.reduce(map, fn {amount, from, to}, acc ->
      picked =
        acc
        |> Map.get(from)
        |> Enum.take(amount)

      acc
      |> Map.put(from, Map.get(acc, from) -- picked)
      |> Map.put(to, picked ++ Map.get(acc, to))
    end)
    |> Enum.map(fn {_, v} ->
      List.first(v)
    end)
    |> Enum.join()
  end

  def input() do
    input =
      "priv/day5/input.txt"
      |> File.read!()

    [map, actions] =
      input
      |> String.split("\n\n", trim: true)

    actions =
      actions
      |> String.split("\n", trim: true)
      |> Enum.map(fn line ->
        ["move", amount, "from", from, "to", to] =
          line
          |> String.split(" ")

        {String.to_integer(amount), String.to_integer(from), String.to_integer(to)}
      end)

    map
    |> String.split("\n", trim: true)
    |> Enum.reverse()
    |> Enum.map(fn line ->
      line
      |> String.split(" ", trim: false)
    end)

    map =
      map
      |> String.split("\n", trim: true)
      |> Enum.drop(-1)
      |> Enum.map(&String.split(&1, "", trim: true))
      |> Enum.map(&Enum.chunk_every(&1, 4))

    map =
      for row <- map do
        for cell <- row do
          case cell do
            ["[", char, "]" | _] -> char
            _ -> nil
          end
        end
      end
      |> Enum.zip_with(& &1)
      |> Enum.map(fn chars -> Enum.reject(chars, &is_nil/1) end)
      |> Enum.with_index(1)
      |> Map.new(fn {stack, i} -> {i, stack} end)

    {map, actions}
  end
end
