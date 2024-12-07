defmodule Aoc.Day7 do
  @doc """
      iex> "priv/day7/example.txt" |> Aoc.Day7.input() |> Aoc.Day7.part1()
      3749
  """
  def part1(list) do
    list
    |> Enum.filter(fn {test_val, nums} ->
      dfs(0, nums, test_val)
    end)
    |> Stream.map(fn {test_val, _} -> test_val end)
    |> Enum.sum()
  end

  def dfs(sum, [], test_val), do: sum == test_val

  def dfs(sum, [l], test_val) do
    dfs(sum + l, [], test_val) || dfs(sum * l, [], test_val)
  end

  def dfs(sum, [h | t], test_val) do
    if sum == 0 do
      dfs(sum + h, t, test_val)
    else
      dfs(sum + h, t, test_val) || dfs(sum * h, t, test_val)
    end
  end

  @doc """
      iex> "priv/day7/example.txt" |> Aoc.Day7.input() |> Aoc.Day7.part2()
      11387
  """
  def part2(list) do
    list
    |> Enum.filter(fn {test_val, nums} ->
      dfs2(0, nums, test_val)
    end)
    |> Stream.map(fn {test_val, _} -> test_val end)
    |> Enum.sum()
  end

  def dfs2(sum, [], test_val), do: sum == test_val

  def dfs2(sum, [l], test_val) do
    dfs2(sum + l, [], test_val) || dfs2(sum * l, [], test_val) ||
      dfs2(String.to_integer(Integer.to_string(sum) <> Integer.to_string(l)), [], test_val)
  end

  def dfs2(sum, [h | t], test_val) do
    if sum == 0 do
      dfs2(sum + h, t, test_val)
    else
      dfs2(sum + h, t, test_val) || dfs2(sum * h, t, test_val) ||
        dfs2(String.to_integer(Integer.to_string(sum) <> Integer.to_string(h)), t, test_val)
    end
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [test_val, nums_s] =
        line
        |> String.split(": ", trim: true)

      nums =
        nums_s
        |> String.split(" ", trim: true)
        |> Enum.map(&String.to_integer/1)

      {String.to_integer(test_val), nums}
    end)
  end
end
