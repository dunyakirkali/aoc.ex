defmodule Aoc.Day2 do
  def score_game({opp, you}) do
    case opp do
      :r ->
        case you do
          :r -> 3
          :p -> 6
          :s -> 0
        end

      :p ->
        case you do
          :r -> 0
          :p -> 3
          :s -> 6
        end

      :s ->
        case you do
          :r -> 6
          :p -> 0
          :s -> 3
        end
    end
  end

  defp score_move(:r), do: 1
  defp score_move(:p), do: 2
  defp score_move(:s), do: 3

  def decide_move({opp, exp}) do
    case opp do
      :r ->
        case exp do
          "X" -> :s
          "Y" -> :r
          "Z" -> :p
        end

      :p ->
        case exp do
          "X" -> :r
          "Y" -> :p
          "Z" -> :s
        end

      :s ->
        case exp do
          "X" -> :p
          "Y" -> :s
          "Z" -> :r
        end
    end
  end

  @doc """
      iex> "priv/day2/example.txt" |> Aoc.Day2.input |> Aoc.Day2.part1()
      15
  """
  def part1(list) do
    list
    |> Enum.map(fn [opp, you] ->
      opp =
        case opp do
          "A" -> :r
          "B" -> :p
          "C" -> :s
        end

      you =
        case you do
          "X" -> :r
          "Y" -> :p
          "Z" -> :s
        end

      {opp, you}
    end)
    |> Enum.map(fn move ->
      move
      |> then(fn {_, you} = move ->
        score_move(you) + score_game(move)
      end)
    end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day2/example.txt" |> Aoc.Day2.input |> Aoc.Day2.part2()
      12
  """
  def part2(list) do
    list
    |> Enum.map(fn [opp, exp] ->
      opp =
        case opp do
          "A" -> :r
          "B" -> :p
          "C" -> :s
        end

      you = decide_move({opp, exp})
      {opp, you}
    end)
    |> Enum.map(fn move ->
      move
      |> then(fn {_, you} = move ->
        score_move(you) + score_game(move)
      end)
    end)
    |> Enum.sum()
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split(&1, " ", trim: true))
  end
end
