defmodule Aoc.Day9 do
  @doc """
      iex> "priv/day9/example.txt" |> Aoc.Day9.input() |> Aoc.Day9.part1()
      1928
  """
  def part1(list) do
    list
    |> expand(0, :file, [])
    |> move()
    |> score()
  end

  def move(list) do
    first_free = Enum.find_index(list, fn x -> x == "." end)

    last_file =
      list
      |> Enum.with_index()
      |> Enum.reduce(nil, fn
        {x, i}, _acc when is_integer(x) -> i
        _, acc -> acc
      end)

    if first_free > last_file do
      list
    else
      move(swap(list, first_free, last_file))
    end
  end

  def swap(a, i1, i2) do
    e1 = Enum.at(a, i1)
    e2 = Enum.at(a, i2)

    a
    |> List.replace_at(i1, e2)
    |> List.replace_at(i2, e1)
  end

  @doc """
      iex> Aoc.Day9.score([0, 0, 9, 9, 8, 1, 1, 1, 8, 8, 8, 2, 7, 7, 7, 3, 3, 3, 6, 4, 4, 6, 5, 5, 5, 5, 6, 6, ".", ".", ".", ".", ".", ".", ".", ".", "."])
      1928

  """
  def score(list) do
    list
    |> Enum.with_index()
    |> Enum.reduce(0, fn {item, index}, acc ->
      case item do
        "." -> acc
        _ -> acc + item * index
      end
    end)
  end

  @doc """
      iex> Aoc.Day9.expand([1, 2, 3, 4, 5], 0, :file, [])
      [0, ".", ".", 1, 1, 1, ".", ".", ".", ".", 2, 2, 2, 2, 2]

      iex> Aoc.Day9.expand([9, 0, 9, 0, 9], 0, :file, [])
      [0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 2, 2, 2]
  """
  def expand([l], id, :file, acc),
    do: [for(_ <- 1..l, do: id) | acc] |> List.flatten() |> Enum.reverse()

  def expand([l], _, :free, acc),
    do: [for(_ <- 1..l, do: ".") | acc] |> List.flatten() |> Enum.reverse()

  def expand([l | t], id, :file, acc),
    do: expand(t, id + 1, :free, [for(_ <- 1..l, do: id) | acc])

  def expand([l | t], id, :free, acc),
    do: expand(t, id, :file, [String.duplicate(".", l) |> String.graphemes() | acc])

  @doc """
      iex> "priv/day9/example.txt" |> Aoc.Day9.input() |> Aoc.Day9.part2()
      2858
  """
  def part2(list) do
    {files, frees} =
      list
      |> unzip()

    {files, frees}
    |> zip()
    |> move2(Enum.reverse(files))
    |> score2(0, 0)
  end

  def score2([], acc, _), do: acc

  def score2([h | t], acc, offset) do
    case h do
      {size, index} ->
        acc =
          List.duplicate(index, size)
          |> Enum.with_index()
          |> Enum.reduce(acc, fn {val, ind}, accc ->
            accc + val * (ind + offset)
          end)

        score2(t, acc, offset + size)

      int ->
        score2(t, acc, offset + int)
    end
  end

  def zip({list1, list2}) do
    zip_lists(list1, list2, [])
  end

  defp zip_lists([l], [], acc), do: Enum.reverse([l | acc])

  defp zip_lists([h1 | t1], [h2 | t2], acc) do
    zip_lists(t1, t2, [h2, h1 | acc])
  end

  @doc """
      iex> Aoc.Day9.move2([{2, 0}, 3, {3, 1}, 3, {1, 2}, 3, {3, 3}, 1, {2, 4}, 1, {4, 5}, 1, {4, 6}, 1, {3, 7}, 1, {4, 8}, 0, {2, 9}], [{2,9}])
      [{2, 0}, {2, 9}, 1, {3, 1}, 3, {1, 2}, 3, {3, 3}, 1, {2, 4}, 1, {4, 5}, 1, {4, 6}, 1, {3, 7}, 1, {4, 8}, 2]

      iex> Aoc.Day9.move2([{2, 0}, {2, 9}, 1, {3, 1}, 3, {1, 2}, 3, {3, 3}, 1, {2, 4}, 1, {4, 5}, 1, {4, 6}, 1, {3, 7}, 1, {4, 8}, 2], [{4,8}])
      [{2, 0}, {2, 9}, 1, {3, 1}, 3, {1, 2}, 3, {3, 3}, 1, {2, 4}, 1, {4, 5}, 1, {4, 6}, 1, {3, 7}, 1, {4, 8}, 2]

      iex> Aoc.Day9.move2([{2, 0}, {2, 9}, 1, {3, 1}, 3, {1, 2}, 3, {3, 3}, 1, {2, 4}, 1, {4, 5}, 1, {4, 6}, 1, {3, 7}, 1, {4, 8}, 2], [{3,7}])
      [{2, 0}, {2, 9}, 1, {3, 1}, {3,7}, {1, 2}, 3, {3, 3}, 1, {2, 4}, 1, {4, 5}, 1, {4, 6}, 5, {4, 8}, 2]

      iex> Aoc.Day9.move2([{2, 0}, {2, 9}, 1, {3, 1}, {3,7}, {1, 2}, 3, {3, 3}, 1, {2, 4}, 1, {4, 5}, 1, {4, 6}, 5, {4, 8}, 2], [{4,6}])
      [{2, 0}, {2, 9}, 1, {3, 1}, {3,7}, {1, 2}, 3, {3, 3}, 1, {2, 4}, 1, {4, 5}, 1, {4, 6}, 5, {4, 8}, 2]

      iex> Aoc.Day9.move2([{2, 0}, {2, 9}, 1, {3, 1}, {3,7}, {1, 2}, 3, {3, 3}, 1, {2, 4}, 1, {4, 5}, 1, {4, 6}, 5, {4, 8}, 2], [{4,5}])
      [{2, 0}, {2, 9}, 1, {3, 1}, {3,7}, {1, 2}, 3, {3, 3}, 1, {2, 4}, 1, {4, 5}, 1, {4, 6}, 5, {4, 8}, 2]

      iex> Aoc.Day9.move2([{2, 0}, {2, 9}, 1, {3, 1}, {3,7}, {1, 2}, 3, {3, 3}, 1, {2, 4}, 1, {4, 5}, 1, {4, 6}, 5, {4, 8}, 2], [{2,4}])
      [{2, 0}, {2, 9}, 1, {3, 1}, {3, 7}, {1, 2}, {2, 4}, 1, {3, 3}, 4, {4, 5}, 1, {4, 6}, 5, {4, 8}, 2]

      iex> Aoc.Day9.move2([{2, 0}, {2, 9}, 1, {3, 1}, {3, 7}, {1, 2}, {2, 4}, 1, {3, 3}, 4, {4, 5}, 1, {4, 6}, 5, {4, 8}, 2], [{1,2}])
      [{2, 0}, {2, 9}, {1, 2}, {3, 1}, {3, 7}, 1, {2, 4}, 1, {3, 3}, 4, {4, 5}, 1, {4, 6}, 5, {4, 8}, 2]

      iex> Aoc.Day9.move2([{2, 0}, {2, 9}, {1, 2}, {3, 1}, {3, 7}, 1, {2, 4}, 1, {3, 3}, 4, {4, 5}, 1, {4, 6}, 5, {4, 8}, 2], [{3,1}])
      [{2, 0}, {2, 9}, {1, 2}, {3, 1}, {3, 7}, 1, {2, 4}, 1, {3, 3}, 4, {4, 5}, 1, {4, 6}, 5, {4, 8}, 2]

      iex> Aoc.Day9.move2([{2, 0}, {2, 9}, {1, 2}, {3, 1}, {3, 7}, 1, {2, 4}, 1, {3, 3}, 4, {4, 5}, 1, {4, 6}, 5, {4, 8}, 2], [{2,0}])
      [{2, 0}, {2, 9}, {1, 2}, {3, 1}, {3, 7}, 1, {2, 4}, 1, {3, 3}, 4, {4, 5}, 1, {4, 6}, 5, {4, 8}, 2]
  """
  def move2(list, []), do: list

  def move2(list, [{size, id} | tail]) do
    case Enum.find_index(list, &(is_integer(&1) and &1 >= size)) do
      nil ->
        move2(list, tail)

      target_index ->
        case Enum.find_index(list, &(&1 == {size, id})) do
          from_index when target_index >= from_index ->
            move2(list, tail)

          from_index ->
            available_space = Enum.at(list, target_index)

            list
            |> List.replace_at(from_index, size)
            |> List.replace_at(target_index, [0, {size, id}, available_space - size])
            |> List.flatten()
            |> merge_consecutive_integers()
            |> move2(tail)
        end
    end
  end

  def merge_consecutive_integers(list) do
    list
    |> Enum.reduce({[], 0}, fn
      tuple = {_, _}, {acc, 0} ->
        {[tuple | acc], 0}

      tuple = {_, _}, {acc, carry} ->
        {[tuple, carry | acc], 0}

      int, {acc, carry} when is_integer(int) ->
        {acc, carry + int}
    end)
    |> finalize_result()
  end

  defp finalize_result({acc, 0}), do: Enum.reverse(acc)
  defp finalize_result({acc, carry}), do: Enum.reverse([carry | acc])

  def unzip(array) do
    Enum.with_index(array)
    |> Enum.reduce({[], []}, fn {element, index}, {list1, list2} ->
      if rem(index, 2) == 0 do
        {[element | list1], list2}
      else
        {list1, [element | list2]}
      end
    end)
    |> then(fn {list1, list2} ->
      {Enum.reverse(list1) |> Enum.with_index(), Enum.reverse(list2)}
    end)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.trim()
    |> String.graphemes()
    |> Enum.map(fn x -> String.to_integer(x) end)
  end
end
