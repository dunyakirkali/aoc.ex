defmodule Aoc.Day22 do
  @doc """
      iex> inp = Aoc.Day22.input("priv/day22/example.txt")
      ...> Aoc.Day22.part1(inp)
      306
  """
  def part1(inp) do
    game = parse_game(inp)

    1..10000
    |> Enum.reduce_while(game, fn _, acc ->
      if Enum.empty?(acc["1"]) or Enum.empty?(acc["2"]) do
        {:halt, acc}
      else
        [p1 | t1] = acc["1"]
        [p2 | t2] = acc["2"]

        res =
          cond do
            p1 > p2 ->
              %{"1" => t1 ++ [p1, p2], "2" => t2}

            p1 < p2 ->
              %{"1" => t1, "2" => t2 ++ [p2, p1]}
          end

        {:cont, res}
      end
    end)
    |> Enum.map(fn {_k, v} ->
      score(v)
    end)
    |> Enum.max()
  end

  @doc """
      iex> Aoc.Day22.score([3, 2, 10, 6, 8, 5, 9, 4, 7, 1])
      306
  """
  def score(hand) do
    hand
    |> Enum.reverse()
    |> Enum.with_index()
    |> Enum.reduce(0, fn {x, ind}, acc ->
      (ind + 1) * x + acc
    end)
  end

  def parse_game(inp) do
    inp
    |> Enum.map(fn group ->
      [info | cards] =
        group
        |> String.split("\n", trim: true)

      res = Regex.named_captures(~r/Player (?<no>\d):/, info)
      {res["no"], Enum.map(cards, fn x -> String.to_integer(x) end)}
    end)
    |> Enum.into(%{})
  end

  @doc """
      iex> inp = Aoc.Day22.input("priv/day22/example.txt")
      ...> Aoc.Day22.part2(inp)
      291
  """
  def part2(inp) do
    %{"1" => d1, "2" => d2} = parse_game(inp)

    {d1, d2}
    |> play()
    |> score()
  end

  def play(decks) do
    decks
    |> play([], [])
    |> elem(1)
  end

  def play({[], player_2}, _, _) do
    {2, player_2}
  end

  def play({player_1, []}, _, _) do
    {1, player_1}
  end

  def play({[card_1 | rest_1] = a, [card_2 | rest_2] = b}, h1, h2) do
    if a in h1 || b in h2 do
      {1, a}
    else
      h1 = [a | h1]
      h2 = [b | h2]

      if card_1 <= length(rest_1) && card_2 <= length(rest_2) do
        case play({Enum.take(rest_1, card_1), Enum.take(rest_2, card_2)}, [], []) do
          {1, _} -> play({rest_1 ++ [card_1, card_2], rest_2}, h1, h2)
          {2, _} -> play({rest_1, rest_2 ++ [card_2, card_1]}, h1, h2)
        end
      else
        case card_1 > card_2 do
          true -> play({rest_1 ++ [card_1, card_2], rest_2}, h1, h2)
          _ -> play({rest_1, rest_2 ++ [card_2, card_1]}, h1, h2)
        end
      end
    end
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n\n", trim: true)
  end
end
