defmodule Aoc.Day15 do
  @doc """
      iex> "priv/day15/example.txt" |> Aoc.Day15.input() |> Aoc.Day15.part1()
      1320
  """
  def part1(map) do
    map
    |> Enum.map(fn piece -> hash(piece) end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day15/example.txt" |> Aoc.Day15.input() |> Aoc.Day15.part2()
      145
  """
  def part2(map) do
    boxes =
      0..255
      |> Enum.reduce(%{}, fn i, acc ->
        Map.put(acc, i, [])
      end)

    map
    |> Enum.map(fn piece ->
      cond do
        String.match?(piece, ~r/.+=\d/) ->
          [label, focal_length] =
            String.split(piece, "=", trim: true)

          {:set, label, hash(label), String.to_integer(focal_length)}

        String.match?(piece, ~r/.+-/) ->
          label = String.replace(piece, "-", "")
          {:remove, label, hash(label)}
      end
    end)
    |> Enum.reduce(boxes, fn action, acc ->
      {_, acc} =
        case action do
          {:remove, label, box} ->
            Map.get_and_update(acc, box, fn current_value ->
              {current_value,
               Enum.filter(current_value, fn {lbl, _} ->
                 label != lbl
               end)}
            end)

          {:set, label, box, focal_length} ->
            Map.get_and_update(acc, box, fn current_value ->
              if Enum.filter(current_value, fn {lbl, _} -> label == lbl end)
                 |> Enum.count()
                 |> Kernel.==(1) do
                {current_value,
                 Enum.map(current_value, fn {lbl, fl} ->
                   if lbl == label do
                     {lbl, focal_length}
                   else
                     {lbl, fl}
                   end
                 end)}
              else
                {current_value, current_value ++ [{label, focal_length}]}
              end
            end)
        end

      acc
    end)
    |> Enum.map(fn {box, list} ->
      list
      |> Enum.with_index()
      |> Enum.map(fn {{_, fl}, index} ->
        (index + 1) * fl * (box + 1)
      end)
    end)
    |> List.flatten()
    |> Enum.sum()
  end

  @doc """
      iex> "HASH" |> Aoc.Day15.hash()
      52
  """
  def hash(str), do: do_hash(str, 0)
  def do_hash(<<>>, acc), do: acc

  def do_hash(<<ch::utf8, rest::binary>>, acc) do
    acc = acc + ch
    acc = acc * 17
    acc = rem(acc, 256)

    do_hash(rest, acc)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.split(",", trim: true)
  end
end
