# TODO: (dunyakirkali) Revisit Part2
defmodule Aoc.Day16 do
  @doc """
      iex> inp = Aoc.Day16.input("priv/day16/example.txt")
      ...> Aoc.Day16.part1(inp)
      71
  """
  def part1(inp) do
    [raw_rules, mine, theirs] = inp
    rules = parse_rules(raw_rules)
    mine =
      mine
      |> String.split("\n", trim: true)
      |> List.last()
      |> parse_ticket()

    theirs =
      theirs
      |> String.split("\n", trim: true)
      |> List.delete_at(0)
      |> Enum.map(fn x ->
        parse_ticket(x)
      end)

    calc(rules, theirs, [])
    |> Enum.map(fn t ->
      elem(t, 0)
    end)
    |> Enum.sum
  end

  def calc(rules, theirs, acc) do
    theirs
    |> Enum.with_index
    |> Enum.reduce(acc, fn {the, ind}, acc ->
      the
      |> Enum.reduce(acc, fn val, acc ->
        exists =
          rules
          |> Enum.map(fn r ->
            elem(r, 1)
          end)
          |> Enum.reduce(false, fn pair, acc -> # while
            inpair =
              pair
              |> Enum.reduce(false, fn rr, acc -> # while
                acc || Enum.member?(rr, val)
              end)

            acc || inpair
          end)

        if exists do
          acc
        else
          [{val, ind} | acc]
        end
      end)
    end)
  end

  def calc2(rules, theirs, acc) do
    theirs
    |> Enum.with_index
    |> Enum.reduce(acc, fn {the, ind}, acc ->
      the
      |> Enum.reduce(acc, fn val, acc ->
        exists =
          rules
          |> Stream.map(fn r ->
            elem(r, 1)
          end)
          |> Stream.scan(false, fn pair, acc -> # while
            inpair =
              pair
              |> Enum.reduce_while(false, fn rr, acc -> # while
                mem = Enum.member?(rr, val)
                if mem do
                  {:cont, acc || mem}
                else
                  {:halt, false}
                end
              end)

            if inpair do
              {:cont, acc || inpair}
            else
              {:halt, false}
            end
          end)
          |> Enum.to_list
        |>List.last

        if exists do
          acc
        else
          [{val, ind} | acc]
        end
      end)
    end)
  end

  def parse_ticket(ticket) do
    ticket
    |> String.split(",")
    |> Enum.map(fn x ->
      String.to_integer(x)
    end)
  end

  def parse_rules(rules) do
    rules
    |> String.split("\n", trim: true)
    |> Enum.map(fn x ->
      x
      |> String.split(": ", trim: true)
    end)
    |> Enum.reduce(%{}, fn [rule_name, rule], acc ->
      ranges =
        rule
        |> String.split(" or ")
        |> Enum.map(fn x ->
          [s, e] =
            x
            |> String.split("-", trim: true)
            |> Enum.map(fn y ->
              String.to_integer(y)
            end)

          Range.new(s, e)
        end)
      Map.put(acc, rule_name, ranges)
    end)
  end

  @doc """
      iex> inp = Aoc.Day16.input("priv/day16/example2.txt")
      ...> Aoc.Day16.part2(inp)
      1716
  """
  def part2(inp) do
    [raw_rules, mine, theirs] = inp
    rules = parse_rules(raw_rules)
    mine =
      mine
      |> String.split("\n", trim: true)
      |> List.last()
      |> parse_ticket()

    theirs =
      theirs
      |> String.split("\n", trim: true)
      |> List.delete_at(0)
      |> Enum.map(fn x ->
        parse_ticket(x)
      end)

    tis = calc2(rules, theirs, [])

    theirs =
      tis
      |> Enum.reduce(theirs, fn {_, ind}, acc ->
        List.delete_at(acc, ind)
      end)

    find_fields(rules, [mine | theirs])
    |> Enum.zip(mine)
    |> IO.inspect
    |> Enum.filter(fn {name, _val} ->
      String.starts_with?(name, "departure")
    end)
    |> Enum.map(fn {_, val} ->
      val
    end)
    |> Enum.reduce(1, fn val, acc ->
      acc * val
    end)
  end

  @doc """
      iex> Aoc.Day16.find_fields(%{"class" => [0..1, 4..19], "row" => [0..5, 8..19], "seat" => [0..13, 16..19]}, [[11,12,13], [3,9,18], [15,1,5], [5,14,9]])
      ["row", "class", "seat"]
  """
  def find_fields(rules, tickets) do
    rule_sets =
      rules
      |> Aoc.Parallel.pmap(fn {k, v} ->
        ves =
          v
          |> Enum.reduce(MapSet.new(), fn ran, acc ->
            if MapSet.size(acc) == 0 do
              MapSet.new(ran)
            else
              MapSet.union(acc, MapSet.new(ran))
            end
          end)
        {k, ves}
      end)
      |> Enum.into([])

    cols =
      tickets
      |> Enum.reduce(%{}, fn ticket, acc ->
        ticket
        |> Enum.with_index

        |> Enum.reduce(acc, fn {item, ind}, acc ->
          Map.update(acc, ind, [item], fn old -> [item | old] end)
        end)
      end)
      IO.puts("bef")

    cols
    |> Map.keys
    |> Aoc.LazyPermutations.permutations
    |> Stream.with_index
    |> Stream.map(fn {com, p} ->
      reses =
        com
        |> Enum.with_index
        |> Enum.map(fn {col, ind} ->
          col_vals = Map.get(cols, col)
          MapSet.subset?(MapSet.new(col_vals), rule_sets |> Enum.at(ind) |> elem(1))
        end)
      {com, reses}
    end)
    |> Enum.to_list
    |> Enum.find(fn {_com, reses} ->
      Enum.all?(reses)
    end)
    |> elem(0)
    |> Aoc.Parallel.pmap(fn pos ->
      rules
      |> Map.keys
      |> Enum.at(pos)
    end)
  end

  def input(filename) do
    filename
    |> File.read!()
    |> String.split("\n\n", trim: true)
  end
end
