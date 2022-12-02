defmodule Aoc.Day2 do
  defmodule RPS do
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

    def score_move(move) do
      case move do
        :r -> 1
        :p -> 2
        :s -> 3
      end
    end

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
  end

  @doc """
      iex> Aoc.Day2.part1([["A", "Y"], ["B", "X"], ["C", "Z"]])
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
        RPS.score_move(you) + RPS.score_game(move)
      end)
    end)
    |> Enum.sum
  end

  @doc """
      iex> Aoc.Day2.part2([["A", "Y"], ["B", "X"], ["C", "Z"]])
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
      you = RPS.decide_move({opp, exp})
      {opp, you}
    end)
    |> Enum.map(fn move ->
      move
      |> then(fn {_, you} = move ->
        RPS.score_move(you) + RPS.score_game(move)
      end)
    end)
    |> Enum.sum
  end

  def input() do
    "priv/day2/input.txt"
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(&(String.split(&1, " ", trim: true)))
  end
end
