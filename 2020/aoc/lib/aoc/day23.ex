defmodule Aoc.Day23 do
  @total 100
  @total2 10_000_000

  @doc """
      iex> Aoc.Day23.part1("389125467")
      "67384529"
  """
  def part1(inp) do
    cups =
      inp
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)

    cup_count = 9

    cups
    |> move(0, @total, cup_count)
    |> rotate_to()
    |> Enum.join()
  end

  def rotate_to([h | t]) when h == 1 do
    t
  end

  def rotate_to(cups) do
    cups
    |> left_rotate(1)
    |> rotate_to
  end

  def move(cups, round, cap, _cup_count) when round == cap do
    cups
  end

  def move([h, p1, p2, p3 | rem] = cups, round, cap, cup_count) do
    picked = [p1, p2, p3]
    d = deist(cups, picked, cup_count)

    ind = Enum.find_index([h] ++ rem, fn x -> x == d end)

    nl =
      ([h] ++ rem)
      |> List.insert_at(ind + 1, picked)
      |> List.flatten()

    ci = Enum.find_index(nl, fn x -> x == h end)

    move(left_rotate(nl, ci + 1), round + 1, cap, cup_count)
  end

  def left_rotate(l, n \\ 1)
  def left_rotate([], _), do: []
  def left_rotate(l, 0), do: l
  def left_rotate([h | t], 1), do: t ++ [h]
  def left_rotate(l, n) when n > 0, do: left_rotate(left_rotate(l, 1), n - 1)
  def left_rotate(l, n), do: right_rotate(l, -n)

  def right_rotate(l, n \\ 1)
  def right_rotate(l, n) when n > 0, do: Enum.reverse(l) |> left_rotate(n) |> Enum.reverse()
  def right_rotate(l, n), do: left_rotate(l, -n)

  def deist([h | _], picked, cup_count) do
    sub(h, picked, cup_count)
  end

  def sub(cl, picked, cup_count) do
    cl = if cl == 1, do: cup_count, else: cl - 1

    if Enum.member?(picked, cl) do
      sub(cl, picked, cup_count)
    else
      cl
    end
  end

  @doc """
      iex> Aoc.Day23.part2("389125467")
      149245887792
  """
  def part2(inp) do
    cups =
      inp
      |> String.split("", trim: true)
      |> Enum.map(&String.to_integer/1)

    cups = cups ++ Enum.to_list((Enum.max(cups) + 1)..1_000_000)
    [h | t] = cups
    values = t ++ [h]
    mcups = Enum.zip(cups, values) |> Map.new()

    maxl = Enum.max(cups)
    minl = Enum.min(cups)
    r = move(mcups, minl, maxl, h, 0, @total2)
    a = Map.get(r, 1)
    b = Map.get(r, a)
    a * b
  end

  def move(cups, _minl, _maxl, _current, n, t) when n == t do
    cups
  end

  def move(cups, minl, maxl, current, n, t) do
    # identify 3 cups
    p1 = Map.get(cups, current)
    p2 = Map.get(cups, p1)
    p3 = Map.get(cups, p2)
    # and the one after p3, so we can link current to it
    p4 = Map.get(cups, p3)

    dest = get_dest(current - 1, [p1, p2, p3], minl, maxl)
    # "move" actually just update 4 links
    old_after_dest = Map.get(cups, dest)
    cups = Map.put(cups, dest, p1)
    cups = Map.put(cups, p3, old_after_dest)
    cups = Map.put(cups, current, p4)

    move(cups, minl, maxl, p4, n + 1, t)
  end

  def get_dest(dest, picked, min, max) when dest < min do
    get_dest(max, picked, min, max)
  end

  def get_dest(dest, picked, min, max) do
    if dest in picked do
      get_dest(dest - 1, picked, min, max)
    else
      dest
    end
  end
end
