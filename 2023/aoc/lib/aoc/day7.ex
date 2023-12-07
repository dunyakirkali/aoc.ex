defmodule Aoc.Day7 do
  defmodule Card do
    defstruct [:value]

    @doc """
        iex> Aoc.Day7.Card.compare(%Aoc.Day7.Card{value: "A"}, %Aoc.Day7.Card{value: "K"})
        :gt

        iex> Aoc.Day7.Card.compare(%Aoc.Day7.Card{value: "K"}, %Aoc.Day7.Card{value: "Q"})
        :gt

        iex> Aoc.Day7.Card.compare(%Aoc.Day7.Card{value: "Q"}, %Aoc.Day7.Card{value: "J"})
        :gt

        iex> Aoc.Day7.Card.compare(%Aoc.Day7.Card{value: "J"}, %Aoc.Day7.Card{value: "T"})
        :gt

        iex> Aoc.Day7.Card.compare(%Aoc.Day7.Card{value: "T"}, %Aoc.Day7.Card{value: "9"})
        :gt

        iex> Aoc.Day7.Card.compare(%Aoc.Day7.Card{value: "9"}, %Aoc.Day7.Card{value: "8"})
        :gt
    """
    def compare(%Card{value: same}, %Card{value: same}),
      do: :eq

    def compare(%Card{value: "A"}, %Card{value: _}),
      do: :gt

    def compare(%Card{value: _}, %Card{value: "A"}),
      do: :lt

    def compare(%Card{value: "K"}, %Card{value: _}),
      do: :gt

    def compare(%Card{value: _}, %Card{value: "K"}),
      do: :lt

    def compare(%Card{value: "Q"}, %Card{value: _}), do: :gt

    def compare(%Card{value: _}, %Card{value: "Q"}), do: :lt

    def compare(%Card{value: "J"}, %Card{value: _}),
      do: :gt

    def compare(%Card{value: _}, %Card{value: "J"}),
      do: :lt

    def compare(%Card{value: "T"}, %Card{value: _}), do: :gt

    def compare(%Card{value: _}, %Card{value: "T"}), do: :lt

    def compare(%Card{value: lv}, %Card{value: rv}) when lv > rv, do: :gt

    def compare(%Card{value: lv}, %Card{value: rv}) when lv < rv, do: :lt

    def compare2(%Card{value: "J"}, %Card{value: _}),
      do: :lt

    def compare2(%Card{value: _}, %Card{value: "J"}),
      do: :gt

    def compare2(%Card{value: same}, %Card{value: same}),
      do: :eq

    def compare2(%Card{value: "A"}, %Card{value: _}),
      do: :gt

    def compare2(%Card{value: _}, %Card{value: "A"}),
      do: :lt

    def compare2(%Card{value: "K"}, %Card{value: _}),
      do: :gt

    def compare2(%Card{value: _}, %Card{value: "K"}),
      do: :lt

    def compare2(%Card{value: "Q"}, %Card{value: _}), do: :gt

    def compare2(%Card{value: _}, %Card{value: "Q"}), do: :lt

    def compare2(%Card{value: "T"}, %Card{value: _}), do: :gt

    def compare2(%Card{value: _}, %Card{value: "T"}), do: :lt

    def compare2(%Card{value: lv}, %Card{value: rv}) when lv > rv, do: :gt

    def compare2(%Card{value: lv}, %Card{value: rv}) when lv < rv, do: :lt
  end

  defmodule HandWithBid do
    defstruct [:bid, :hand, :score]

    def new({hand, bid}) do
      %HandWithBid{hand: hand, bid: bid, score: score(hand)}
    end

    @doc """
        iex> ["A", "A", "A", "A", "A"] |> Aoc.Day7.HandWithBid.score()
        :five_of_a_kind

        iex> ["A", "A", "8", "A", "A"] |> Aoc.Day7.HandWithBid.score()
        :four_of_a_kind

        iex> ["2", "3", "3", "3", "2"] |> Aoc.Day7.HandWithBid.score()
        :full_house

        iex> ["T", "T", "T", "9", "8"] |> Aoc.Day7.HandWithBid.score()
        :three_of_a_kind

        iex> ["2", "3", "4", "3", "2"] |> Aoc.Day7.HandWithBid.score()
        :two_pair

        iex> ["A", "2", "3", "A", "4"] |> Aoc.Day7.HandWithBid.score()
        :one_pair

        iex> ["2", "3", "4", "5", "6"] |> Aoc.Day7.HandWithBid.score()
        :high_card
    """
    def score(hand) do
      frequencies = Enum.frequencies(hand)

      five_of_a_kind =
        frequencies
        |> Map.values()
        |> Enum.member?(5)

      four_of_a_kind =
        frequencies
        |> Map.values()
        |> Enum.member?(4)

      full_house =
        frequencies
        |> Map.values()
        |> then(fn vals ->
          Enum.count(vals) == 2 and Enum.reduce(vals, 1, fn val, acc -> val * acc end) == 6
        end)

      three_of_a_kind =
        frequencies
        |> Map.values()
        |> Enum.member?(3)

      two_pair =
        frequencies
        |> Map.values()
        |> Enum.filter(fn count ->
          count == 2
        end)
        |> Enum.count()
        |> Kernel.==(2)

      one_pair =
        frequencies
        |> Map.values()
        |> Enum.filter(fn count ->
          count == 2
        end)
        |> Enum.count()
        |> Kernel.==(1)

      high_card =
        frequencies
        |> Map.values()
        |> Enum.filter(fn count ->
          count == 1
        end)
        |> Enum.count()
        |> Kernel.==(5)

      cond do
        five_of_a_kind -> :five_of_a_kind
        four_of_a_kind -> :four_of_a_kind
        full_house -> :full_house
        three_of_a_kind -> :three_of_a_kind
        two_pair -> :two_pair
        one_pair -> :one_pair
        high_card -> :high_card
      end
    end

    @doc """
        iex> Aoc.Day7.HandWithBid.tie_brake([%Aoc.Day7.Card{value: "K"}, %Aoc.Day7.Card{value: "K"}, %Aoc.Day7.Card{value: "6"}, %Aoc.Day7.Card{value: "7"}, %Aoc.Day7.Card{value: "7"}], [%Aoc.Day7.Card{value: "K"}, %Aoc.Day7.Card{value: "T"}, %Aoc.Day7.Card{value: "J"}, %Aoc.Day7.Card{value: "J"}, %Aoc.Day7.Card{value: "T"}])
        :gt

        iex> Aoc.Day7.HandWithBid.tie_brake([%Aoc.Day7.Card{value: "T"}, %Aoc.Day7.Card{value: "5"}, %Aoc.Day7.Card{value: "5"}, %Aoc.Day7.Card{value: "J"}, %Aoc.Day7.Card{value: "5"}], [%Aoc.Day7.Card{value: "Q"}, %Aoc.Day7.Card{value: "Q"}, %Aoc.Day7.Card{value: "Q"}, %Aoc.Day7.Card{value: "J"}, %Aoc.Day7.Card{value: "A"}])
        :lt
    """
    def tie_brake([dl], [dr]), do: Aoc.Day7.Card.compare(dl, dr)
    def tie_brake([same | rl], [same | rr]), do: tie_brake(rl, rr)
    def tie_brake([hl | _], [hr | _]), do: Aoc.Day7.Card.compare(hl, hr)

    def tie_brake2([dl], [dr]), do: Aoc.Day7.Card.compare2(dl, dr)
    def tie_brake2([same | rl], [same | rr]), do: tie_brake2(rl, rr)
    def tie_brake2([hl | _], [hr | _]), do: Aoc.Day7.Card.compare2(hl, hr)

    @doc """
        iex> Aoc.Day7.HandWithBid.compare(%Aoc.Day7.HandWithBid{score: :five_of_a_kind}, %Aoc.Day7.HandWithBid{score: :four_of_a_kind})
        :gt

        iex> Aoc.Day7.HandWithBid.compare(%Aoc.Day7.HandWithBid{score: :three_of_a_kind}, %Aoc.Day7.HandWithBid{score: :two_pair})
        :gt

        iex> Aoc.Day7.HandWithBid.compare(%Aoc.Day7.HandWithBid{score: :two_pair}, %Aoc.Day7.HandWithBid{score: :three_of_a_kind})
        :lt
    """
    def compare(%HandWithBid{score: same, hand: hl}, %HandWithBid{score: same, hand: hr}),
      do: tie_brake(hl, hr)

    def compare(%HandWithBid{score: :five_of_a_kind}, %HandWithBid{score: _}),
      do: :gt

    def compare(%HandWithBid{score: _}, %HandWithBid{score: :five_of_a_kind}),
      do: :lt

    def compare(%HandWithBid{score: :four_of_a_kind}, %HandWithBid{score: _}),
      do: :gt

    def compare(%HandWithBid{score: _}, %HandWithBid{score: :four_of_a_kind}),
      do: :lt

    def compare(%HandWithBid{score: :full_house}, %HandWithBid{score: _}),
      do: :gt

    def compare(%HandWithBid{score: _}, %HandWithBid{score: :full_house}),
      do: :lt

    def compare(%HandWithBid{score: :three_of_a_kind}, %HandWithBid{score: _}),
      do: :gt

    def compare(%HandWithBid{score: _}, %HandWithBid{score: :three_of_a_kind}),
      do: :lt

    def compare(%HandWithBid{score: :two_pair}, %HandWithBid{score: _}),
      do: :gt

    def compare(%HandWithBid{score: _}, %HandWithBid{score: :two_pair}),
      do: :lt

    def compare(%HandWithBid{score: :one_pair}, %HandWithBid{score: _}),
      do: :gt

    def compare(%HandWithBid{score: _}, %HandWithBid{score: :one_pair}),
      do: :lt

    def compare(%HandWithBid{score: :high_card}, %HandWithBid{score: _}),
      do: :gt

    def compare(%HandWithBid{score: _}, %HandWithBid{score: :high_card}),
      do: :lt

    def compare2(%HandWithBid{score: same, hand: hl}, %HandWithBid{score: same, hand: hr}),
      do: tie_brake2(hl, hr)

    def compare2(%HandWithBid{score: :five_of_a_kind}, %HandWithBid{score: _}),
      do: :gt

    def compare2(%HandWithBid{score: _}, %HandWithBid{score: :five_of_a_kind}),
      do: :lt

    def compare2(%HandWithBid{score: :four_of_a_kind}, %HandWithBid{score: _}),
      do: :gt

    def compare2(%HandWithBid{score: _}, %HandWithBid{score: :four_of_a_kind}),
      do: :lt

    def compare2(%HandWithBid{score: :full_house}, %HandWithBid{score: _}),
      do: :gt

    def compare2(%HandWithBid{score: _}, %HandWithBid{score: :full_house}),
      do: :lt

    def compare2(%HandWithBid{score: :three_of_a_kind}, %HandWithBid{score: _}),
      do: :gt

    def compare2(%HandWithBid{score: _}, %HandWithBid{score: :three_of_a_kind}),
      do: :lt

    def compare2(%HandWithBid{score: :two_pair}, %HandWithBid{score: _}),
      do: :gt

    def compare2(%HandWithBid{score: _}, %HandWithBid{score: :two_pair}),
      do: :lt

    def compare2(%HandWithBid{score: :one_pair}, %HandWithBid{score: _}),
      do: :gt

    def compare2(%HandWithBid{score: _}, %HandWithBid{score: :one_pair}),
      do: :lt

    def compare2(%HandWithBid{score: :high_card}, %HandWithBid{score: _}),
      do: :gt

    def compare2(%HandWithBid{score: _}, %HandWithBid{score: :high_card}),
      do: :lt
  end

  @doc """
      iex> "priv/day7/example.txt" |> Aoc.Day7.input() |> Aoc.Day7.part1()
      6440
  """
  def part1(input) do
    input
    |> Enum.sort({:asc, Aoc.Day7.HandWithBid})
    |> Enum.with_index()
    |> Enum.map(fn {%HandWithBid{bid: bid}, rank} -> bid * (rank + 1) end)
    |> Enum.sum()
  end

  @doc """
      iex> "priv/day7/example.txt" |> Aoc.Day7.input() |> Aoc.Day7.part2()
      5905
  """
  def part2(input) do
    input
    |> Enum.map(fn hand -> strengthen(hand) end)
    |> Enum.sort(fn lh, rh ->
      case Aoc.Day7.HandWithBid.compare2(lh, rh) do
        :lt -> true
        :gt -> false
      end
    end)
    |> IO.inspect(label: "Part 2: sorted")
    |> Enum.with_index()
    |> Enum.map(fn {%HandWithBid{bid: bid}, rank} -> bid * (rank + 1) end)
    |> Enum.sum()
  end

  def strengthen(%HandWithBid{bid: bid, hand: hand} = hwb) do
    ["A", "K", "Q", "T", "9", "8", "7", "6", "5", "4", "3", "2"]
    |> Enum.map(fn option ->
      hand =
        hand
        |> Enum.map(fn card -> if card.value == "J", do: option, else: card.value end)
        |> Enum.map(fn v -> %Card{value: v} end)

      HandWithBid.new({hand, bid})
    end)
    |> Enum.sort({:desc, Aoc.Day7.HandWithBid})
    |> Enum.at(0)
    |> Map.get(:score)
    |> then(fn bs -> %{hwb | score: bs} end)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n", trim: true)
    |> Enum.map(fn line ->
      [hand_str, bid_str] =
        line
        |> String.split(" ", trim: true)

      HandWithBid.new(
        {String.split(hand_str, "", trim: true) |> Enum.map(fn x -> %Card{value: x} end),
         String.to_integer(bid_str)}
      )
    end)
  end
end
